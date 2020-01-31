//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import Foundation

public class ThrottlingLoader: HTTPLoader {
    private let queue = DispatchQueue(label: "ThrottlingLoader")
    
    public var maximumNumberOfTasks: Int {
        get { queue.sync { onqueue_maxNumberOfTasks } }
        set {
            queue.async {
                self.onqueue_maxNumberOfTasks = newValue
                self.onqueue_executeNextTasksIfNecessary()
            }
        }
    }
    
    private var onqueue_maxNumberOfTasks = 0
    private var onqueue_executingTasks = Dictionary<UUID, HTTPTask>()
    private var onqueue_pendingTasks = LinkedList<HTTPTask>()
    
    public init(maximumNumberOfTasks: Int = 0) {
        onqueue_maxNumberOfTasks = maximumNumberOfTasks
        super.init()
    }
    
    public override func load(task: HTTPTask) {
        queue.async {
            // always throw the task on to the queue
            // this means we can have unified logic for
            // "should this task be executed"
            self.onqueue_enqueuePendingTask(task)
            self.onqueue_executeNextTasksIfNecessary()
        }
    }
    
    private func onqueue_enqueuePendingTask(_ task: HTTPTask) {
        // if the task is cancelled, it needs to be pulled off the queue
        // and it needs to be manually failed
        self.onqueue_pendingTasks.append(task)
        task.addCancelHandler { [weak self, weak task] in
            guard let self = self else { return }
            guard let task = task else { return }
            self.queue.async {
                dispatchPrecondition(condition: .onQueue(self.queue))
                if let index = self.onqueue_pendingTasks.firstIndex(where: { $0 === task }) {
                    self.onqueue_pendingTasks.remove(at: index).fail(.cancelled)
                }
            }
        }
    }
    
    private func onqueue_executeNextTasksIfNecessary() {
        while let next = onqueue_popNextPendingTask() {
            onqueue_loadImmediately(task: next)
        }
    }
    
    private func onqueue_popNextPendingTask() -> HTTPTask? {
        if onqueue_maxNumberOfTasks <= 0 || onqueue_executingTasks.count < onqueue_maxNumberOfTasks {
            return onqueue_pendingTasks.popFirst()
        }
        return nil
    }
    
    private func onqueue_loadImmediately(task: HTTPTask) {
        guard let next = nextLoader else {
            task.fail(.cannotConnect)
            return
        }
        
        let identifier = task.identifier
        onqueue_executingTasks[identifier] = task
        
        task.addCompletionHandler { [weak self] result in
            guard let self = self else { return }
            self.queue.async {
                self.onqueue_executingTasks[identifier] = nil
                self.onqueue_executeNextTasksIfNecessary()
            }
        }
        
        next.load(task: task)
    }
    
    public override func reset(with group: DispatchGroup) {
        group.enter()
        
        queue.async {
            self.onqueue_pendingTasks.forEach { task in
                group.enter()
                task.addCompletionHandler { _ in group.leave() }
                task.cancel()
            }
            
            self.onqueue_executingTasks.values.forEach { task in
                group.enter()
                task.addCompletionHandler { _ in group.leave() }
                task.cancel()
            }
            
            // we don't need to clear out the list nor dictionary
            // as that will happen as a side-effect of the tasks
            // cancelling and/or completing
            
            group.leave()
        }
        
        nextLoader?.reset(with: group)
    }
    
}

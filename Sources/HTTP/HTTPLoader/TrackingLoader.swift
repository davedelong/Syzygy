//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public class TrackingLoader: HTTPLoader {
    
    private let queue = DispatchQueue(label: "TrackingLoader")
    private var tasks = Dictionary<UUID, HTTPTask>()
    
    public override func load(task: HTTPTask) {
        guard let next = nextLoader else {
            task.fail(.cannotConnect)
            return
        }
        
        queue.sync {
            let id = task.identifier
            tasks[id] = task
            task.addCompletionHandler { _ in
                self.queue.sync {
                    self.tasks[id] = nil
                }
            }
        }
        next.load(task: task)
    }
    
    public override func reset(with group: DispatchGroup) {
        group.enter()
        queue.async {
            let copy = self.tasks
            self.tasks = [:]
            DispatchQueue.global().async {
                for (_, task) in copy {
                    group.enter()
                    task.addCompletionHandler { _ in group.leave() }
                    task.cancel()
                }
                group.leave()
            }
        }
        
        nextLoader?.reset(with: group)
    }
    
}

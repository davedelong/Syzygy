//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import Foundation

public enum RequestModificationResult {
    case modified(HTTPRequest)
    case error(HTTPError)
    case needsNewModifier
}

public protocol RequestModifier {
    func modify(request: HTTPRequest) -> RequestModificationResult
}

open class RequestModifyingLoader: HTTPLoader {
    
    private let queue = DispatchQueue(label: "RequestModifyingLoader")
    
    private var resetCount: UInt = 0
    
    #warning("TODO: limit the number of times this can successively attempt to retrieve a modifier")
    
    private var modifier: Retrieved<RequestModifier> = .unretrieved
    private var pendingTasks = LinkedList<HTTPTask>()
    
    public override init() {
        if type(of: self) == RequestModifyingLoader.self {
            fatalError("RequestModifyingLoader may not be instantiated directly. Use a subclass.")
        }
        super.init()
    }
    
    public override func load(task: HTTPTask) {
        queue.async {
            
            switch self.modifier {
                case .unretrieved:
                    self.pendingTasks.append(task)
                    // start retrieval
                    self.onqueue_startRetrievingModifier()
                
                case .inProgress(_):
                    self.pendingTasks.append(task)
                    // do nothing
                
                case .retrieved(let modifier):
                    // apply the modifier
                    _ = self.onqueue_applyModifier(modifier, to: task)
            }
            
        }
    }
    
    public override func reset(with group: DispatchGroup) {
        group.enter()
        queue.async {
            self.resetCount += 1
            self.modifier.inProgressWork?.cancel()
            
            // cancel all pending tasks
            group.enter()
            self.onqueue_failAllPendingRequests(with: .cancelled, underlyingError: nil, completion: {
                group.leave()
            })
            
            group.leave()
        }
    }
    
    open func retrieveModifier(using loader: HTTPLoader?, completion: @escaping (RequestModifier) -> Void) {
        fatalError("\(type(of: self)) does not override \(#function)")
    }
    
    public func loadImmediately(_ task: HTTPTask) {
        if let next = nextLoader {
            next.load(task: task)
        } else {
            task.fail(.cannotConnect)
        }
    }
    
    private func onqueue_startRetrievingModifier() {
        dispatchPrecondition(condition: .onQueue(queue))
        
        let count = resetCount
        let work = DispatchWorkItem {
            self.retrieveModifier(using: self.nextLoader, completion: { modifier in
                self.queue.async {
                    self.onqueue_finishRetrievingModifier(modifier, lastResetCount: count)
                }
            })
        }
        modifier = .inProgress(work)
        DispatchQueue.global().async(execute: work)
    }
    
    private func onqueue_finishRetrievingModifier(_ modifier: RequestModifier, lastResetCount: UInt) {
        dispatchPrecondition(condition: .onQueue(queue))
        
        // if the resetCount has changed, then we were reset while the retrieval was in-progress
        guard lastResetCount == resetCount else { return }
        
        self.modifier = .retrieved(modifier)
        
        while let next = pendingTasks.popFirst() {
            let keepGoing = onqueue_applyModifier(modifier, to: next)
            if keepGoing == false {
                break
            }
        }
    }
    
    private func onqueue_applyModifier(_ modifier: RequestModifier, to task: HTTPTask) -> Bool {
        dispatchPrecondition(condition: .onQueue(queue))
        
        switch modifier.modify(request: task.request) {
            case .modified(let modifiedRequest):
                // this also checks to make sure the new request is a MODIFICATION
                // of the old request, and is not a completely new request
                task.setRequest(modifiedRequest)
                loadImmediately(task)
                return true
            case .error(let error):
                task.fail(error)
                return true
            case .needsNewModifier:
                self.modifier = .unretrieved
                pendingTasks.insert(task, at: 0)
                onqueue_startRetrievingModifier()
                return false
        }
    }
    
    private func onqueue_failAllPendingRequests(with code: HTTPError.Code, underlyingError: Error?, completion: @escaping () -> Void) {
        dispatchPrecondition(condition: .onQueue(queue))
        
        let requests = pendingTasks
        pendingTasks = []
        
        let group = DispatchGroup()
        for task in requests {
            group.enter()
            task.addCompletionHandler { _ in group.leave() }
            let error = HTTPError(code: code, request: task.request, response: nil, underlyingError: underlyingError)
            task.fail(error)
        }
        group.notify(queue: .global(), execute: completion)
    }
    
    public func failAllPendingRequests(with code: HTTPError.Code, underlyingError: Error? = nil, completion: @escaping () -> Void) {
        queue.async {
            self.onqueue_failAllPendingRequests(with: code, underlyingError: underlyingError, completion: completion)
        }
    }
    
}

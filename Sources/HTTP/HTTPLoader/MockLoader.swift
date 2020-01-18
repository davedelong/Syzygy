//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public class MockLoader: HTTPLoader {
    
    public typealias Handler = (HTTPTask) -> Void
    
    private var nextHandlers = LinkedList<Handler>()
    
    public var assertsForUncompletedTasks: Bool = true
    public var numberOfLoads: Int = 0
    public var resetHandler: (DispatchGroup) -> Void = { _ in }
    
    public override func load(task: HTTPTask) {
        numberOfLoads += 1
        
        if let next = nextHandlers.popFirst() {
            next(task)
        } else {
            task.fail(.cannotConnect)
        }
        
        if assertsForUncompletedTasks == true && task.result == nil {
            let taskID = task.identifier
            fatalError("MockLoader handled task \(taskID) but did not complete it")
        }
    }
    
    @discardableResult
    public func then(_ handler: @escaping Handler) -> MockLoader {
        nextHandlers.append(handler)
        return self
    }
    
    public override func reset(with group: DispatchGroup) {
        numberOfLoads = 0
        resetHandler(group)
    }
    
}

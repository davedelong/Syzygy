//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

open class HTTPLoader {
    
    public init() {
        if type(of: self) == HTTPLoader.self {
            fatalError("HTTPLoader may not be instantiated directly. Use a subclass.")
        }
    }
    
    public private(set) final var nextLoader: HTTPLoader?
    
    public final func setNextLoader(_ loader: HTTPLoader) {
        if nextLoader != nil {
            fatalError("Cannot set the nextLoader of an HTTPLoader after it has already been set")
        }
        
        nextLoader = loader
    }
    
    open func load(task: HTTPTask) {
        fatalError("Subclasses of HTTPLoader must implement \(#function)")
    }
    
    open func reset(with group: DispatchGroup) {
        nextLoader?.reset(with: group)
    }
    
    @discardableResult
    public final func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) -> HTTPTask {
        let task = HTTPTask(request: request, completion: completion)
        load(task: task)
        return task
    }
    
}

/*
 This precendencegroup and operator exist solely to simplify and clarify the declaration of
 HTTPLoader chains.
 */
precedencegroup LoadChainingPrecedence {
    higherThan: NilCoalescingPrecedence
    associativity: left
}

infix operator --> : LoadChainingPrecedence

@discardableResult
public func --> (lhs: HTTPLoader?, rhs: HTTPLoader?) -> HTTPLoader? {
    if let r = rhs {
        lhs?.setNextLoader(r)
    }
    return rhs ?? lhs
}

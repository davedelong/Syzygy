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
    
}

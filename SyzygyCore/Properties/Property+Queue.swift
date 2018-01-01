//
//  Property+Queue.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    public func deliver(on queue: DispatchQueue) -> Property<T> {
        let m = MutableProperty(value)
        let serial = DispatchQueue(label: "delivery<\(type(of: T.self))>", target: queue)
        observeNext { newValue in
            serial.async { m.value = newValue }
        }
        return m
    }
    
    public func delay(_ interval: TimeInterval, on queue: DispatchQueue = .main) -> Property<T> {
        let m = MutableProperty(value)
        let serial = DispatchQueue(label: "delayed<\(type(of: T.self))>", target: queue)
        observeNext { newValue in
            serial.asyncAfter(deadline: .now() + interval) { m.value = newValue }
        }
        return m
    }
    
}

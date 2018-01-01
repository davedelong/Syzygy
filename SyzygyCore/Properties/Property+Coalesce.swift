//
//  Property+Coalesce.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    public func coalesce(after: TimeInterval, on queue: DispatchQueue = .main) -> Property<T> {
        let last = Atomic<Disposable?>(nil)
        let m = MutableProperty(value)
        
        observeNext { new in
            last.modify { previous in
                previous?.dispose()
                let w = DispatchWorkItem { m.value = new }
                let b = ActionDisposable { w.cancel() }
                queue.asyncAfter(deadline: .now() + after, execute: w)
                return b
            }
        }
        
        return m
    }
    
}

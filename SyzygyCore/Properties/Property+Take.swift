//
//  Property+Take.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    @discardableResult
    public func observeNext(_ count: Int, _ observer: @escaping PropertyObserver<T>) -> Disposable {
        return takeNext(count).observeNext(observer)
    }
    
    public func takeNext(_ count: Int) -> Property<T> {
        let m = MutableProperty(value)
        
        if count > 0 {
            var takenSoFar = 0
            var d: Disposable?
            d = observeNext {
                if takenSoFar < count {
                    m.value = $0
                    takenSoFar += 1
                }
                
                if takenSoFar >= count {
                    d?.dispose()
                    d = nil
                }
            }
        }
        
        return m
    }
    
    public func takeUntil<U>(_ other: Property<U>) -> Property<T> {
        let m = MutableProperty(value)
        
        let d = observeNext { m.value = $0 }
        other.observeNext { _ in d.dispose() }
        
        return m
    }
    
    public func takeWhile(_ other: Property<Bool>) -> Property<T> {
        let m = MutableProperty(value)
        
        let taking = Atomic(other.value)
        observeNext { value in
            taking.with { isTaking in
                if isTaking { m.value = value }
            }
        }
        
        other.observeNext { taking.swap($0) }
        
        return m
    }
}

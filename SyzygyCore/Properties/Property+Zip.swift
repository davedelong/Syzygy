//
//  Property+Zip.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    public func zip<U>(_ other: Property<U>) -> Property<(T, U)> {
        
        let initial = (value, other.value)
        let m = MutableProperty(initial)
        let state = Atomic<ZipState<T, U>?>(ZipState<T, U>())
        
        let destroyState = ActionDisposable { state.swap(nil) }
        
        observeNext { left in
            state.with { z in
                if let next = z?.pushLeft(left) {
                    m.value = next
                }
            }
        }
        addCleanupDisposable(destroyState)
        
        other.observeNext { right in
            state.with { z in
                if let next = z?.pushRight(right) {
                    m.value = next
                }
            }
        }
        other.addCleanupDisposable(destroyState)
        
        return m
    }
    
    public func withPrevious(_ initial: T) -> Property<(T, T)> {
        let m = MutableProperty((initial, value))
        observeNext { new in
            m.potentiallyModifyValue {
                return ($0.1, new)
            }
        }
        return m
    }
    
    public func withPrevious() -> Property<(T?, T)> {
        let m = MutableProperty((Optional<T>.none, value))
        observeNext { new in
            m.potentiallyModifyValue {
                return ($0.1, new)
            }
        }
        return m
    }
    
}

private final class ZipState<T, U> {
    private let lock = NSLock()
    private var entries = Array<Either<T, U>>()
    
    func pushLeft(_ value: T) -> (T, U)? {
        if let first = entries.first, case .right(let right) = first {
            entries.removeFirst()
            return (value, right)
        }
        entries.append(.left(value))
        return nil
    }
    
    func pushRight(_ value: U) -> (T, U)? {
        if let first = entries.first, case .left(let left) = first {
            entries.removeFirst()
            return (left, value)
        }
        entries.append(.right(value))
        return nil
    }
}

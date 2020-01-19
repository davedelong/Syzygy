//
//  Property+Skip.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

public extension Property {
    
    func skipNext(_ count: Int) -> Property<T> {
        var skippedSoFar = 0
        
        // we only skip *subsequent* values
        let m = MutableProperty(value)
        observeNext {
            if skippedSoFar >= count {
                m.value = $0
            } else {
                skippedSoFar += 1
            }
        }
        return m
    }
    
    func skipUntil<U>(_ other: Property<U>) -> Property<T> {
        let m = MutableProperty(value)
        
        let skipping = Atomic(true)
        observeNext { value in
            skipping.with { isSkipping in
                if isSkipping == false {
                    m.value = value
                }
            }
        }
        
        other.observeNext { _ in skipping.swap(false) }
        
        return m
    }
    
    func skipWhile(_ other: Property<Bool>) -> Property<T> {
        let m = MutableProperty(value)
        
        let skipping = Atomic(other.value)
        observeNext { value in
            skipping.with { isSkipping in
                if isSkipping == false {
                    m.value = value
                }
            }
        }
        
        other.observeNext { skipping.swap($0) }
        
        return m
    }
    
    func skipRepeats(_ isEqual: @escaping (T, T) -> Bool) -> Property<T> {
        let m = MutableProperty(value)
        observeNext { new in
            m.potentiallyModifyValue {
                if isEqual($0, new) == true { return nil }
                return new
            }
        }
        return m
    }
    
}

public extension Property where T: Equatable {
    
    func skipRepeats() -> Property<T> {
        return skipRepeats(==)
    }
    
}

/*
 public extension Property where T: Collection, T.Iterator.Element: Equatable {
 
 func skipRepeats() -> Property<T> {
 return skipRepeats { (left, right) -> Bool in
 guard left.count == right.count else { return false }
 for (l, r) in Swift.zip(left, right) {
 guard l == r else { return false }
 }
 return true
 }
 }
 
 }
 */

public extension Property where T: Hashable {
    
    /// Skip sending values that have ever been sent before
    ///
    /// - Returns: A new `Property` that only sends values that have have never been sent before
    func skipDuplicates() -> Property<T> {
        let v = value
        var soFar = Set<T>([v])
        
        let m = MutableProperty(v)
        observeNext { new in
            if soFar.contains(new) == false {
                // WARNING: this has unbounded memory growth
                soFar.insert(new)
                m.value = new
            }
        }
        return m
    }
    
}

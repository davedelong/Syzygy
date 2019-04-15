//
//  Property+Filter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    func filter(_ f: @escaping (T) -> Bool) throws -> Property<T> {
        let currentValue = value
        guard f(currentValue) == true else {
            throw PropertyError.missingInitialValue
        }
        
        let m = MutableProperty(currentValue)
        
        observeNext {
            if f($0) { m.value = $0 }
        }
        
        return m
    }
    
    func filterNext(_ f: @escaping (T) -> Bool) -> Property<T> {
        let m = MutableProperty(value)
        
        observeNext {
            if f($0) { m.value = $0 }
        }
        
        return m
    }
    
}

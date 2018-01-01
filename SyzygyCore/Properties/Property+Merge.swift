//
//  Property+Merge.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    public func merge(_ others: Property<T> ...) -> Property<T> {
        return merge(others)
    }
    
    public func merge(_ others: Array<Property<T>>) -> Property<T> {
        let all = [self] + others
        
        // no fear of force unwrapping, because we know that `all` must contain at least `self`
        let m = MutableProperty(all.last!.value)
        
        for property in all {
            property.observeNext { m.value = $0 }
        }
        
        return m
    }
    
}

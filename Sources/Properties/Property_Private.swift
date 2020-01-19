//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/19/20.
//

import Foundation

extension Property {
    
    public func potentiallyModifyValue(_ valueModifier: (T) -> T?) {
        _lock.lock()
        if let newValue = valueModifier(_value) {
            _value = newValue
            for o in _observers.list() {
                o(newValue)
            }
        }
        _lock.unlock()
    }
    
    public func setValue(_ value: T) {
        potentiallyModifyValue { _ in return value }
    }
    
}

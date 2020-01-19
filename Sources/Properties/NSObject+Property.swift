//
//  NSObject+Property.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension NSObject {
    
    func observe<T>(keyPath: String) throws -> Property<T> {
        return try KVOProperty(object: self, keyPath: keyPath)
    }
    
    func observe<T>(keyPath: String, initialValue: T) -> Property<T> {
        return KVOProperty(object: self, keyPath: keyPath, initialValue: initialValue)
    }
    
}

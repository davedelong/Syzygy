//
//  Dictionary.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    func map<NewKey: Hashable, NewValue>(_ block: (Element) throws -> (NewKey, NewValue)) rethrows -> Dictionary<NewKey, NewValue> {
        var mapped = Dictionary<NewKey, NewValue>()
        for (k, v) in self {
            let (nk, nv) = try block((k, v))
            mapped[nk] = nv
        }
        return mapped
    }
    
    mutating func append(contentsOf other: Dictionary<Key, Value>) {
        for (key, value) in other {
            self[key] = value
        }
    }
    
    mutating func value(for key: Key, builder: (Key) -> Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            let built = builder(key)
            self[key] = built
            return built
        }
    }
    
    mutating func value(for key: Key, builder: (Key) -> Value?) -> Value? {
        if let value = self[key] {
            return value
        } else if let built = builder(key) {
            self[key] = built
            return built
        } else {
            return nil
        }
    }
    
}

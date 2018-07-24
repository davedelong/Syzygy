//
//  KeyPathSorter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension KeyPath {
    
    public struct Sorter: Sorting {
        private let keyPath: KeyPath<Root, Value>
        private let ordersBefore: (Value, Value) -> Bool
        
        public init(keyPath: KeyPath<Root, Value>, ordersBefore: @escaping (Value, Value) -> Bool) {
            self.keyPath = keyPath
            self.ordersBefore = ordersBefore
        }
        
        public func orders(_ a: Root, before b: Root) -> Bool {
            return ordersBefore(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
    
    public func sorting(by sorter: @escaping (Value, Value) -> Bool) -> Sorter {
        return Sorter(keyPath: self, ordersBefore: sorter)
    }
}

extension KeyPath: ValueSorting, Sorting where Value: Comparable {
    public typealias Base = Root
    
    public func value(from root: Root) -> Value {
        return root[keyPath: self]
    }
    
    public func ascending() -> Sorter {
        return sorting(by: <)
    }
    
    public func descending() -> Sorter {
        return sorting(by: >)
    }
    
}

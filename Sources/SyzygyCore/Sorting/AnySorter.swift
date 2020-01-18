//
//  AnySorter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct AnySorter<B>: Sorting {
    private let ordersBefore: (B, B) -> Bool
    
    public init(sorter: @escaping (B, B) -> Bool) {
        self.ordersBefore = sorter
    }
    
    public init<S: Sorting>(_ s: S) where S.Base == B {
        ordersBefore = { s.orders($0, before: $1) }
    }
    
    public func orders(_ left: B, before: B) -> Bool {
        return ordersBefore(left, before)
    }
}

public struct AnyValueSorter<B, V: Comparable>: ValueSorting {
    public typealias Base = B
    public typealias Value = V
    
    private let valueExtractor: (B) -> V
    
    public init(_ extractor: @escaping (B) -> V) {
        self.valueExtractor = extractor
    }
    
    public init<S: ValueSorting>(_ s: S) where S.Base == B, S.Value == V {
        self.valueExtractor = { s.value(from: $0) }
    }
    
    public func value(from base: B) -> V {
        return valueExtractor(base)
    }
    
}

//
//  CombinedSorter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct CombinedSorter<B>: Sorting {
    private let firstOrders: (B, B) -> Bool
    private let secondOrders: (B, B) -> Bool
    
    public init<S1: Sorting, S2: Sorting>(_ s1: S1, _ s2: S2) where S1.Base == B, S2.Base == B {
        firstOrders = { s1.orders($0, before: $1) }
        secondOrders = { s2.orders($0, before: $1) }
    }
    
    public func orders(_ left: B, before: B) -> Bool {
        if firstOrders(left, before) { return true }
        if firstOrders(before, left) { return false }
        return secondOrders(left, before)
    }
    
}

public extension Sorting {
    public static func +<S: Sorting>(lhs: Self, rhs: S) -> CombinedSorter<Base> where S.Base == Base {
        return CombinedSorter(lhs, rhs)
    }
}

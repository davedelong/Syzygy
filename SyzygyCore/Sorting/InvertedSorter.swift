//
//  InvertedSorter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct InvertedSorter<B>: Sorting {
    private let ordersBefore: (B, B) -> Bool
    
    public init<S: Sorting>(_ s: S) where S.Base == B {
        ordersBefore = { s.orders($0, before: $1) }
    }
    
    public func orders(_ left: B, before: B) -> Bool {
        return !ordersBefore(left, before)
    }
}

extension Sorting {
    public static prefix func -(value: Self) -> InvertedSorter<Base> {
        return InvertedSorter(value)
    }
}

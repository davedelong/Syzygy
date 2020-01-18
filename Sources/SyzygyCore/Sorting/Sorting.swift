//
//  SortDescriptors.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol Sorting {
    associatedtype Base
    func orders(_ left: Base, before: Base) -> Bool
}

public protocol ValueSorting: Sorting {
    associatedtype Value
    func value(from base: Base) -> Value
}

public extension ValueSorting where Value: Comparable {
    func orders(_ left: Base, before: Base) -> Bool {
        return value(from: left) < value(from: before)
    }
}

public protocol DirectedSorting: Sorting {
    var isAscending: Bool { get }
}

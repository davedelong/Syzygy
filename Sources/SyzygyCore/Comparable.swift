//
//  Comparable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Swift

private func aggregate<C: Collection>(_ values: C, agg: (C.Element, C.Element) -> C.Element) -> C.Element? {
    var final: C.Element?
    for value in values {
        if let f = final {
            final = agg(f, value)
        } else {
            final = value
        }
    }
    return final
}

public func min<C: Collection>(_ values: C) -> C.Element? where C.Element: Comparable {
    return aggregate(values, agg: min)
}

public func max<C: Collection>(_ values: C) -> C.Element? where C.Element: Comparable {
    return aggregate(values, agg: max)
}

public extension Comparable {
    
    func compare(_ other: Self) -> ComparisonResult {
        if self < other { return .orderedAscending }
        if self == other { return .orderedSame }
        return .orderedDescending
    }
    
}

public extension Collection {
    
    func range<C: Comparable>(of value: (Element) -> C) -> ClosedRange<C>? {
        guard isEmpty == false else { return nil }
        var slice = Slice(base: self, bounds: startIndex ..< endIndex)
        let first = slice.removeFirst()
        
        var min = value(first)
        var max = value(first)
        
        for other in slice {
            let otherValue = value(other)
            if otherValue < min { min = otherValue }
            if otherValue > max { max = otherValue }
        }
        return min ... max
    }
    
}

public extension Collection where Element: Comparable {
    
    func range() -> ClosedRange<Element>? {
        return range(of: { $0 })
    }
    
}

//
//  Comparable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

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
    
    public func compare(_ other: Self) -> ComparisonResult {
        if self < other { return .orderedAscending }
        if self == other { return .orderedSame }
        return .orderedDescending
    }
    
}

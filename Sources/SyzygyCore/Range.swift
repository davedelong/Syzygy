//
//  Range.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol Ranging {
    associatedtype Bound
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
    init(uncheckedBounds bounds: (lower: Bound, upper: Bound))
}

extension Range: Ranging { }
extension ClosedRange: Ranging { }

public extension Ranging where Bound: SignedNumeric {
    var span: Bound { return upperBound - lowerBound }
}

public extension Ranging where Bound: Comparable {
    
    func clamping(_ value: Bound) -> Bound {
        if value < lowerBound { return lowerBound }
        if value > upperBound { return upperBound }
        return value
    }
    
}

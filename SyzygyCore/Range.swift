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
    public var span: Bound { return upperBound - lowerBound }
}

public extension Ranging where Bound: Comparable {
    
    public func clamping(_ value: Bound) -> Bound {
        if value < lowerBound { return lowerBound }
        if value > upperBound { return upperBound }
        return value
    }
    
}

public extension Ranging where Bound: Interpolatable {
    
    public func value(at percentile: Double, interpolator: Interpolating = LinearInterpolator()) -> Bound {
        if percentile <= 0 { return lowerBound }
        if percentile >= 1 { return upperBound }
        
        let offset = span.scale(by: percentile, interpolator: interpolator)
        return lowerBound + offset
    }
    
    public func percentile(at value: Bound, interpolator: ReverseInterpolating = LinearInterpolator()) -> Double {
        if value <= lowerBound { return 0 }
        if value >= upperBound { return 1 }
        
        return span.percentage(of: value, interpolator: interpolator)
    }
    
}

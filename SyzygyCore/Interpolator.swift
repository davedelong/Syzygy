//
//  Interpolator.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/28/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol Interpolating {
    func interpolate(_ value: Double) -> Double
}

public protocol ReverseInterpolating: Interpolating {
    func reverseInterpolate(_ value: Double) -> Double
}

public typealias Interpolatable = Scalable & SignedNumeric & Comparable

public extension Interpolating {
    
    func interpolate<T: Interpolatable>(range: ClosedRange<T>, percentile: ClosedRange<Double>) -> ClosedRange<T> {
        let l = range.value(at: percentile.lowerBound, interpolator: self)
        let u = range.value(at: percentile.upperBound, interpolator: self)
        return ClosedRange(uncheckedBounds: (lower: l, upper: u))
    }
    
}

public extension ReverseInterpolating {
    
    func reverseInterpolate<T: Interpolatable>(range: ClosedRange<T>, value: ClosedRange<T>) -> ClosedRange<Double> {
        var l = 0.0
        if value.lowerBound > range.lowerBound {
            l = range.percentile(at: value.lowerBound, interpolator: self)
        }
        
        var u = 1.0
        if value.upperBound < range.upperBound {
            u = range.percentile(at: value.upperBound, interpolator: self)
        }
        return l ... u
    }
    
}

public struct LinearInterpolator: ReverseInterpolating {
    
    public init() { }
    
    public func interpolate(_ value: Double) -> Double {
        return value
    }
    
    public func reverseInterpolate(_ value: Double) -> Double {
        return value
    }
}

public struct LogarithmicInterpolator: ReverseInterpolating {
    
    private let scale = 5.0
    
    public init() { }
    
    public func interpolate(_ value: Double) -> Double {
        let r = scale * value
        return exp(r + 1) / exp(scale + 1)
    }
    
    public func reverseInterpolate(_ value: Double) -> Double {
        let b = value * exp(scale + 1)
        return (log(b) - 1) / scale
    }
    
}

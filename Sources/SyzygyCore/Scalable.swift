//
//  Scalable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol Scalable {
    func scale(by percentage: Double, interpolator: Interpolating) -> Self
    func percentage(of scaledValue: Self, interpolator: ReverseInterpolating) -> Double
}

public extension Scalable {
    
    func scale(by percentage: Double) -> Self {
        return self.scale(by: percentage, interpolator: LinearInterpolator())
    }
    
    func percentage(of scaledValue: Self) -> Double {
        return self.percentage(of: scaledValue, interpolator: LinearInterpolator())
    }
    
}

extension Decimal: Scalable {
    
    public func scale(by percentage: Double, interpolator: Interpolating) -> Decimal {
        return self * Decimal(interpolator.interpolate(percentage))
    }
    
    public func percentage(of scaledValue: Decimal, interpolator: ReverseInterpolating) -> Double {
        let p = scaledValue / self
        let d = NSDecimalNumber(decimal: p).doubleValue
        return interpolator.reverseInterpolate(d)
    }
    
}

extension Double: Scalable {
    
    public func scale(by percentage: Double, interpolator: Interpolating) -> Double {
        return self * interpolator.interpolate(percentage)
    }
    
    public func percentage(of scaledValue: Double, interpolator: ReverseInterpolating) -> Double {
        let p = scaledValue / self
        return interpolator.reverseInterpolate(p)
    }
    
}

extension Measurement: Scalable where UnitType: Dimension {
    
    public func scale(by percentage: Double, interpolator: Interpolating) -> Measurement<UnitType> {
        let newValue = value * interpolator.interpolate(percentage)
        return Measurement(value: newValue, unit: unit)
    }
    
    public func percentage(of scaledValue: Measurement<UnitType>, interpolator: ReverseInterpolating) -> Double {
        let actualValue = scaledValue.converted(to: self.unit)
        let p = actualValue.value / self.value
        return interpolator.reverseInterpolate(p)
    }
    
}

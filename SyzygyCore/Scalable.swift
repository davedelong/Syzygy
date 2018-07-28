//
//  Scalable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Interpolator {
    private static let logScale = 5.0
    
    public static let linear = Interpolator { $0 }
    public static let logarithmic = Interpolator {
        let r = Interpolator.logScale * $0
        return exp(r + 1) / exp(Interpolator.logScale + 1)
    }
    
    public let interpolate: (Double) -> Double
    private init(_ i: @escaping (Double) -> Double) {
        self.interpolate = i
    }
}

public protocol Scalable {
    func scale(by percentage: Double, interpolator: Interpolator) -> Self
}

public extension Scalable {
    func scale(by percentage: Double) -> Self {
        return self.scale(by: percentage, interpolator: .linear)
    }
}

extension Decimal: Scalable {
    public func scale(by percentage: Double, interpolator: Interpolator) -> Decimal {
        return self * Decimal(interpolator.interpolate(percentage))
    }
}

extension Double: Scalable {
    public func scale(by percentage: Double, interpolator: Interpolator) -> Double {
        return self * interpolator.interpolate(percentage)
    }
}

extension Measurement: Scalable {
    public func scale(by percentage: Double, interpolator: Interpolator) -> Measurement<UnitType> {
        let newValue = value * interpolator.interpolate(percentage)
        return Measurement(value: newValue, unit: unit)
    }
}

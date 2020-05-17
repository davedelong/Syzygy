//
//  Interpolator.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/28/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Interpolator {
    
    public static func linear(_ range: ClosedRange<Double>) -> Interpolator {
        let span = range.span
        let lower = range.lowerBound
        return Interpolator(interpolate: { ($0 - lower) / span },
                            reverseInterpolate: { ($0 * span) + lower })
    }
    
    public static func logarithmic(_ range: ClosedRange<Double>, scale: Double) -> Interpolator {
        let s = max(scale, 0.1)
        return Interpolator(interpolate: { exp(s * $0 + 1) / exp(s + 1) },
                            reverseInterpolate: { (log($0 * exp(s + 1)) - 1) / s })
    }
    
    public let interpolate: (Double) -> Double
    public let reverseInterpolate: (Double) -> Double
    
    public init(interpolate: @escaping (Double) -> Double, reverseInterpolate: @escaping (Double) -> Double) {
        self.interpolate = interpolate
        self.reverseInterpolate = reverseInterpolate
    }
}

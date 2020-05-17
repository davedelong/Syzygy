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
    
    public static func logarithmic(_ range: ClosedRange<Double>, scale: Double = 1.0) -> Interpolator {
        let logMin = log1p(range.lowerBound)
        let logRange = log1p(range.upperBound) - log1p(range.lowerBound)
        
        return Interpolator(interpolate: {
                                if $0 == range.lowerBound { return 0 }
                                if $0 == range.upperBound { return 1 }
                                let interpolated = (log1p($0) - logMin) / logRange
                                if scale <= 0 || scale == 1 { return interpolated }
                                return pow(interpolated, 1.0 / scale)
                            },
                            reverseInterpolate: {
                                if $0 == 0 { return range.lowerBound }
                                if $0 == 1 { return range.upperBound }
                                var input = $0
                                if scale > 0 && scale != 1 { input = pow($0, scale) }
                                return expm1((input * logRange) + logMin)
                            }
        )
    }
    
    public let interpolate: (Double) -> Double
    public let reverseInterpolate: (Double) -> Double
    
    public init(interpolate: @escaping (Double) -> Double, reverseInterpolate: @escaping (Double) -> Double) {
        self.interpolate = interpolate
        self.reverseInterpolate = reverseInterpolate
    }
}

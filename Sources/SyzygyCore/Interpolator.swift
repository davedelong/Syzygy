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
    
    public static func logarithmic(_ range: ClosedRange<Double>) -> Interpolator {
        let logRange = log(range.upperBound) - log(range.lowerBound)
        return Interpolator(interpolate: { ($0 - log(range.lowerBound)) / logRange },
                            reverseInterpolate: { ($0 * logRange) + log(range.lowerBound) })
    }
    
    public let interpolate: (Double) -> Double
    public let reverseInterpolate: (Double) -> Double
    
    public init(interpolate: @escaping (Double) -> Double, reverseInterpolate: @escaping (Double) -> Double) {
        self.interpolate = interpolate
        self.reverseInterpolate = reverseInterpolate
    }
}

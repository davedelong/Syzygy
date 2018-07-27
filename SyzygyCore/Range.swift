//
//  Range.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Range where Bound: SignedNumeric {
    public var span: Bound { return upperBound - lowerBound }
    
    public func clamping(_ value: Bound) -> Bound {
        if value < lowerBound { return lowerBound }
        if value > upperBound { return upperBound }
        return value
    }
}

public extension ClosedRange where Bound: SignedNumeric {
    public var span: Bound { return upperBound - lowerBound }
    
    public func clamping(_ value: Bound) -> Bound {
        if value < lowerBound { return lowerBound }
        if value > upperBound { return upperBound }
        return value
    }
}

//
//  CLLocation.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        guard lhs.isValid && rhs.isValid else { return false }
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

public extension CLLocationCoordinate2D {
    
    public var isValid: Bool {
        return CLLocationCoordinate2DIsValid(self)
    }
    
}

//
//  CLLocationCoordinate2D.swift
//  SyzygyLocation
//
//  Created by Dave DeLong on 7/7/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension CLLocationCoordinate2D {
    
    public func distance(to other: CLLocationCoordinate2D) -> Double {
        let l1 = CLLocation(latitude: latitude, longitude: longitude)
        let l2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return l2.distance(from: l1)
    }
    
}

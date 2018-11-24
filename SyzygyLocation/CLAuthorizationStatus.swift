//
//  CLAuthorizationStatus.swift
//  SyzygyLocation
//
//  Created by Dave DeLong on 11/15/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension CLAuthorizationStatus {
    
    public var isAuthorized: Bool {
        if self == .authorizedAlways { return true }
        #if BUILDING_FOR_MOBILE
        if self == .authorizedWhenInUse { return true }
        #endif
        return false
    }
    
}

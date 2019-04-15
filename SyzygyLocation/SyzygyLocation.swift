//
//  SyzygyLocation.swift
//  SyzygyLocation
//
//  Created by Dave DeLong on 7/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation
@_exported import SyzygyCore
@_exported import CoreLocation

public extension Bundle {
    
    static let SyzygyLocation = Bundle(for: SyzygyLocationMarker.self)
    
}

private class SyzygyLocationMarker { }

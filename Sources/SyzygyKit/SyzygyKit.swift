//
//  SyzygyKit.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation
@_exported import SyzygyCore

#if BUILDING_FOR_MAC

@_exported import AppKit

#elseif BUILDING_FOR_MOBILE

@_exported import UIKit

#endif

public extension Bundle {
    
    static let SyzygyKit = Bundle(for: SyzygyKitMarker.self)
    
}

private class SyzygyKitMarker { }

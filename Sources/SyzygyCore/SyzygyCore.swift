//
//  SyzygyCore.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation

#if BUILDING_FOR_MAC
@_exported import CoreServices
#elseif BUILDING_FOR_MOBILE
@_exported import MobileCoreServices
#endif

@_exported import Core
@_exported import StandardLibrary
@_exported import UTI
@_exported import Paths
@_exported import Structures

public extension Bundle {
    
    static let SyzygyCore = Bundle(for: SyzygyCoreMarker.self)
    
}

private class SyzygyCoreMarker { }


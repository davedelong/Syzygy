//
//  SyzygyCore.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation

#if BUILDING_FOR_DESKTOP
@_exported import CoreServices
#else
@_exported import MobileCoreServices
#endif

internal let SyzygyCore = Bundle(for: SyzygyCoreMarker.self)

internal class SyzygyCoreMarker { }

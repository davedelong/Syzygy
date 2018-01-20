//
//  SyzygyCore.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation

#if os(macOS)
@_exported import CoreServices
#else
@_exported import MobileCoreServices
#endif

public let SyzygyCore = Bundle(for: SyzygyCoreMarker.self)

internal class SyzygyCoreMarker { }

//
//  SyzygyRuntime.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation
@_exported import ObjectiveC
@_exported import SyzygyCore

public extension Bundle {
    
    public static let SyzygyRuntime = Bundle(for: SyzygyRuntimeMarker.self)
    
}

private class SyzygyRuntimeMarker { }

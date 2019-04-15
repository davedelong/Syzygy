//
//  SyzygyCore.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

@_exported import Foundation
@_exported import DifferenceKit

public extension Bundle {
    
    static let SyzygyCore = Bundle(for: SyzygyCoreMarker.self)
    
}

private class SyzygyCoreMarker { }


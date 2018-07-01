//
//  PlatformColor.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 6/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias PlatformColor = NSColor
#else
public typealias PlatformColor = UIColor
#endif

public extension PlatformColor {
    
    public static let defaultSelectionColor: PlatformColor = {
        #if BUILDING_FOR_DESKTOP
        return NSColor.selectedMenuItemColor
        #else
        return UIColor.blue
        #endif
    }()
    
}

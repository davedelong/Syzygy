//
//  PlatformResponder.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 6/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias PlatformResponder = NSResponder
#else
public typealias PlatformResponder = UIResponder
#endif


#if BUILDING_FOR_DESKTOP

public extension PlatformResponder {

    var next: PlatformResponder? {
        return nextResponder()
    }

}

#endif

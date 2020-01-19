//
//  NSView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

import Cocoa

public extension NSView {
    
    var isVisible: Bool {
        get { return !isHidden }
        set { isHidden = !newValue }
    }
    
}

#endif

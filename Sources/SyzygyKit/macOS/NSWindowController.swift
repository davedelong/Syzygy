//
//  NSWindowController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

import Cocoa

public extension NSWindowController {
    
    convenience init(contentViewController: NSViewController) {
        let w = NSWindow(contentViewController: contentViewController)
        w.contentView?.wantsLayer = true
        self.init(window: w)
    }
    
}

#endif 

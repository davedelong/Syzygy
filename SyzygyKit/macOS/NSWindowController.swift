//
//  NSWindowController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Cocoa

public extension NSWindowController {
    
    public convenience init(contentViewController: NSViewController) {
        let window = NSWindow(contentViewController: contentViewController)
        self.init(window: window)
    }
    
}

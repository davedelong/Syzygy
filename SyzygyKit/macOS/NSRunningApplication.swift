//
//  NSRunningApplication.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)
    
public extension NSRunningApplication {
    
    public var bundlePath: AbsolutePath? {
        guard let bundleURL = self.bundleURL else { return nil }
        return AbsolutePath(bundleURL)
    }
    
}

#endif

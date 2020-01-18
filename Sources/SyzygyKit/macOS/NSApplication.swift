//
//  NSApplication.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 6/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Cocoa

public extension NSApplication {
    
    struct ProcessType {
        
        /// Foreground applications have a menu bar and appear in the Dock
        public static let foreground = ProcessType(rawValue: kProcessTransformToForegroundApplication)
        
        /// Background applications do not have a menu bar nor appear in the Dock.
        /// These kinds of applications should not have windows or other UI elements.
        public static let background = ProcessType(rawValue: kProcessTransformToBackgroundApplication)
        
        /// UIElement applications do not have a menu bar, nor appear in the Dock.
        /// These kinds of applications may present windows and other UI.
        public static let UIElement = ProcessType(rawValue: kProcessTransformToUIElementApplication)
        
        fileprivate let rawValue: Int
    }
    
    
    /// Transform the type of the current process
    ///
    /// - Parameter processType: The `Type` of the process. This should usually be either `.foreground` or `.UIElement`.
    /// - Returns: `true` if the transformation was successful, and `false` otherwise.
    @discardableResult
    func transform(to processType: ProcessType) -> Bool {
        let state = ProcessApplicationTransformState(processType.rawValue)
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        let status = TransformProcessType(&psn, state)
        return status == noErr
    }
    
}

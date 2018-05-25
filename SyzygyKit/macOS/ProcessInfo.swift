//
//  ProcessInfo.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Cocoa

public extension ProcessInfo {
    
    public enum Kind {
        /// Foreground applications have a menu bar and appear in the Dock
        case foreground
        
        /// Background applications do not have a menu bar nor appear in the Dock.
        /// These kinds of applications should not have windows or other UI elements.
        case background
        
        /// UIElement applications do not have a menu bar, nor appear in the Dock.
        /// These kinds of applications may present windows and other UI.
        case UIElement
    }
    
    
    /// Transform the type of the current process
    ///
    /// - Parameter processType: The `Type` of the process. This should usually be either `.foreground` or `.UIElement`.
    /// - Returns: `true` if the transformation was successful, and `false` otherwise.
    @discardableResult
    public func transform(to processType: Kind) -> Bool {
        let stateValue: Int
        switch processType {
            case .foreground: stateValue = kProcessTransformToForegroundApplication
            case .background: stateValue = kProcessTransformToBackgroundApplication
            case .UIElement: stateValue = kProcessTransformToUIElementApplication
        }
        
        let state = ProcessApplicationTransformState(stateValue)
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        let status = TransformProcessType(&psn, state)
        return status == noErr
    }
    
}

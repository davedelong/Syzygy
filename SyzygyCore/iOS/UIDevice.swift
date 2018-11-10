//
//  UIDevice.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 11/10/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = withUnsafePointer(to: &systemInfo.machine.0) { (ptr: UnsafePointer<Int8>) -> String in
            let ns = NSString(bytes: ptr, length: strlen(ptr), encoding: String.Encoding.utf8.rawValue) ?? ""
            return ns as String
        }
        return machine
    }
    
}

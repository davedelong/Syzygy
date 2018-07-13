//
//  Runtime.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Runtime {
    
    private init() { }
    
    public static func enumerateImages(_ iterator: (Image, inout Bool) -> Void) {
        objc_enumerateImages { (i, objcBool) in
            var keepGoing = true
            let image = Image(path: i)
            iterator(image, &keepGoing)
            objcBool.pointee = ObjCBool(keepGoing)
        }
    }
    
    public static func enumerateClasses(_ iterator: (Class, inout Bool) -> Void) {
        objc_enumerateClasses { (c, objcBool) in
            var keepGoing = true
            let runtimeClass = Class(class: c)
            iterator(runtimeClass, &keepGoing)
            objcBool.pointee = ObjCBool(keepGoing)
        }
    }
    
}

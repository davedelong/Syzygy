//
//  Image.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Image {
    private let path: String
    
    internal init(path: String) {
        self.path = path
    }
    
    public func enumerateClasses(_ iterator: (Class, inout Bool) -> Void) {
        objc_enumerateClassesInImage(path) { (c, objcBool) in
            var keepGoing = true
            let runtimeClass = Class(class: c)
            iterator(runtimeClass, &keepGoing)
            objcBool.pointee = ObjCBool(keepGoing)
        }
    }
    
}

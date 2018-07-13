//
//  Class.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Class {
    private let `class`: AnyClass
    
    internal init(class: AnyClass) {
        self.`class` = `class`
    }
    
}

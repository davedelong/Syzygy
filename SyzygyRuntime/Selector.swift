//
//  Selector.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Selector {
    
    public var numberOfArguments: UInt { return sel_getNumberOfArguments(self) }
    public var components: Array<String> { return sel_getComponents(self) }
    
}

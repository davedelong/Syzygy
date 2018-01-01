//
//  Boolean.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol BooleanType {
    
    var boolValue: Bool { get }
    
    func negated() -> Self
    
}

extension Bool: BooleanType {
    
    public var boolValue: Bool { return self }
    
    public func negated() -> Bool { return !self }
    
}

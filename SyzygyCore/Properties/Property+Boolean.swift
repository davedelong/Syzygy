//
//  Property+Boolean.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property where T == Bool {
    
    public static let `true` = Property(true)
    public static let `false` = Property(false)
    
}

public extension Property where T: BooleanType {
    
    public func negated() -> Property<T> {
        return map { $0.negated() }
    }
    
}

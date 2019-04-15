//
//  Property+Tickle.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    func tickle<U>(_ other: Property<U>) -> Property<T> {
        return combine(other).map { $0.0 }
    }
    
}

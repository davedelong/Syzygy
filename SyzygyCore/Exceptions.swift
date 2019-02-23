//
//  Exceptions.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public func catchException<T>(_ block: () -> T) throws -> T {
    var result: T!
    try ObjectiveC.catchException {
        result = block()
    }
    return result
}

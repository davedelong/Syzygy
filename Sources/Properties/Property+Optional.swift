//
//  Property+Optional.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

public extension Property where T: OptionalType {
    
    static var empty: Property<T> { return Property<T>(T.init(nil)) }
    
    func ignoreNil() throws -> Property<T.Wrapped> {
        let initial = try value.optionalValue ?! PropertyError.missingInitialValue
        let m = MutableProperty(initial)
        observeNext {
            if let v = $0.optionalValue { m.value = v }
        }
        return m
    }
    
}

public extension Property where T: OptionalType, T.Wrapped: Equatable {
    
    func skipRepeats() -> Property<T> {
        return skipRepeats { $0.optionalValue == $1.optionalValue }
    }
    
}

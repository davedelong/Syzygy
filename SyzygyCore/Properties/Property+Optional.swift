//
//  Property+Optional.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property where T: OptionalType {
    
    public func ignoreNil() throws -> Property<T.ValueType> {
        let initial = try value.optionalValue ?! PropertyError.missingInitialValue
        let m = MutableProperty(initial)
        observeNext {
            if let v = $0.optionalValue { m.value = v }
        }
        return m
    }
    
}

public extension Property where T: OptionalType, T.ValueType: Equatable {
    
    public func skipRepeats() -> Property<T> {
        return skipRepeats { $0.optionalValue == $1.optionalValue }
    }
    
}

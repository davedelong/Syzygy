//
//  Property+Result.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property where T: ResultType {
    
    public func ignoreError() throws -> Property<T.SuccessType> {
        let initial = try value.success ?! PropertyError.missingInitialValue 
        let m = MutableProperty(initial)
        
        observeNext {
            if let v = $0.success { m.value = v }
        }
        
        return m
    }
    
}

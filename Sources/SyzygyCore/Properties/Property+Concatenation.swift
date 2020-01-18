//
//  Property+Concatenation.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import StandardLibrary

public extension Property where T: Concatenatable {
    
    func concatenateValues(_ others: Property<T> ...) -> Property<T> {
        let all = [self] + others
        let combined = Property.combine(all)
        return combined.map { values in
            var result = values[0]
            for i in values[1...] {
                result = result + i
            }
            return result
        }
    }
    
}

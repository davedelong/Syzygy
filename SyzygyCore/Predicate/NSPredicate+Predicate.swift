//
//  NSPredicate+Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension NSPredicate: Predicate {
    
    public func contains(_ value: Any) -> Bool {
        let b = (try? catchException {
            self.evaluate(with: value)
        }) ?? false
        return b
    }
    
}

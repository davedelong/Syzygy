//
//  File.swift
//  
//
//  Created by Dave DeLong on 2/25/20.
//

import Foundation
import Syzygy_ObjC

extension Predicate where Element: NSObjectProtocol {
    
    init(nsPredicate: NSPredicate) {
        self.init({ object in
            var c = false
            try? ObjectiveC.catchException {
                c = nsPredicate.evaluate(with: object)
            }
            return c
        })
    }
    
}

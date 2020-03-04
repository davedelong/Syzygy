//
//  SetAlgebra+Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Predicate {
    
    init<S: SetAlgebra>(_ algebraicSet: S) where S.Element == Element {
        self.init({ algebraicSet.contains($0) })
    }
    
}

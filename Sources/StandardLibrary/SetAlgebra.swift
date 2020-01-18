//
//  SetAlgebra.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension SetAlgebra {
    
    func intersects(_ other: Self) -> Bool {
        return self.isDisjoint(with: other) == false
    }
    
}

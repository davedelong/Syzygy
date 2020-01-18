//
//  Concatenation.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol Concatenatable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension String: Concatenatable { }
extension Array: Concatenatable { }
extension Set: Concatenatable {
    public static func +(lhs: Set<Element>, rhs: Set<Element>) -> Set<Element> {
        return lhs.union(rhs)
    }
}

//
//  Type.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Type: Equatable {
    private let raw: String
    
    internal static func types(from string: String) -> Array<Type> {
        let types = type_getTypes(string)
        return types.map { Type(raw: $0) }
    }
    
    public static func ==(lhs: Type, rhs: Type) -> Bool {
        return type_isEqualToType(lhs.raw, rhs.raw)
    }
}

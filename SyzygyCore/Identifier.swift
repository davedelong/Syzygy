//
//  Identifier.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public struct Identifier<T>: Newtype, Equatable, Hashable {
    public let rawValue: String
    public var hashValue: Int { return rawValue.hashValue }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}

extension Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self.init(rawValue: value) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(rawValue: value) }
    public init(unicodeScalarLiteral value: String) { self.init(rawValue: value) }
}

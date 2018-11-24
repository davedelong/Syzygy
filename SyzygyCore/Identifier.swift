//
//  Identifier.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public typealias Map<T> = Dictionary<Identifier<T>, T>
public typealias IdentifierSet<T> = Set<Identifier<T>>

public struct Identifier<T>: Newtype, Equatable, Hashable, Codable {
    public let rawValue: String
    public var hashValue: Int { return rawValue.hashValue }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = .init(rawValue: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
}

extension Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self.init(rawValue: value) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(rawValue: value) }
    public init(unicodeScalarLiteral value: String) { self.init(rawValue: value) }
}

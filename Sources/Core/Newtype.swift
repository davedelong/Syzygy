//
//  Newtype.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol Newtype: RawRepresentable {
    init(rawValue: RawValue)
}

extension Newtype where Self: Decodable, RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        self.init(rawValue: try c.decode(RawValue.self))
    }
}

extension Newtype where Self: Encodable, RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        try c.encode(self.rawValue)
    }
}

extension Newtype where Self: Equatable, RawValue: Equatable {
    public static func ==(left: Self, right: Self) -> Bool {
        return left.rawValue == right.rawValue
    }
}

extension Newtype where Self: Comparable, RawValue: Comparable {
    public static func <(left: Self, right: Self) -> Bool {
        return left.rawValue < right.rawValue
    }
}

extension Newtype where Self: Hashable, RawValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.rawValue.hash(into: &hasher)
    }
}

extension Newtype where Self: ExpressibleByStringLiteral, RawValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: RawValue.StringLiteralType) {
        self.init(rawValue: RawValue(stringLiteral: value))
    }
}

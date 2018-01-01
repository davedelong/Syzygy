//
//  JSONInitializable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol JSONInitializable {
    
    init(path: String, json: JSON) throws
    
}

public protocol JSONStringInitializable: JSONInitializable {
    init?(rawValue: String)
}

extension JSONStringInitializable {
    
    public init(path: String, json: JSON) throws {
        let s = try json.string ?! JSONError.wrongKind(json, expected: .string)
        self = try Self.init(rawValue: s) ?! JSONError.cannotInitialize(Self.self, from: json)
    }
    
}

extension Bool: JSONInitializable {
    public init(path: String, json: JSON) throws {
        self = try json.bool ?! JSONError.wrongKind(json, expected: .boolean)
    }
}

extension String: JSONInitializable {
    public init(path: String, json: JSON) throws {
        self = try json.string ?! JSONError.wrongKind(json, expected: .string)
    }
}

extension Double: JSONInitializable {
    public init(path: String, json: JSON) throws {
        self = try json.number ?! JSONError.wrongKind(json, expected: .number)
    }
}

extension Int: JSONInitializable {
    public init(path: String, json: JSON) throws {
        let d = try json.number ?! JSONError.wrongKind(json, expected: .number)
        self = Int(d)
    }
}

extension UInt16: JSONInitializable {
    public init(path: String, json: JSON) throws {
        let d = try json.number ?! JSONError.wrongKind(json, expected: .number)
        self = UInt16(d)
    }
}

extension URL: JSONInitializable {
    public init(path: String, json: JSON) throws {
        let s = try json.string ?! JSONError.wrongKind(json, expected: .number)
        let u = try URL(string: s) ?! JSONError.cannotInitialize(URL.self, from: json)
        self = u
    }
}

private let isoParser = ISO8601DateFormatter()
extension Date: JSONInitializable {
    public init(path: String, json: JSON) throws {
        let s = try json.string ?! JSONError.wrongKind(json, expected: .string)
        self = try isoParser.date(from: s) ?! JSONError.cannotInitialize(Date.self, from: json)
    }
}



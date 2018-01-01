//
//  JSON+Equatable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension JSON: Equatable { }

public func ==(lhs: JSON, rhs: JSON) -> Bool {
    switch (lhs, rhs) {
        case (.unknown, .unknown): return true
        case (.null, .null): return true
        case (.string(let l), .string(let r)): return l == r
        case (.number(let l), .number(let r)): return l == r
        case (.boolean(let l), .boolean(let r)): return l == r
        case (.array(let l), .array(let r)): return l == r
        case (.object(let l), .object(let r)): return l == r
        default: return false
    }
}

public func ==(lhs: JSON, rhs: Double) -> Bool {
    guard case let .number(n) = lhs else { return false }
    return n == rhs
}

public func ==(lhs: JSON, rhs: Bool) -> Bool {
    guard case let .boolean(b) = lhs else { return false }
    return b == rhs
}

public func ==(lhs: JSON, rhs: String) -> Bool {
    guard case let .string(s) = lhs else { return false }
    return s == rhs
}

public func ==(lhs: JSON, rhs: Array<JSON>) -> Bool {
    guard case let .array(a) = lhs else { return false }
    return a == rhs
}

public func ==(lhs: JSON, rhs: Dictionary<String, JSON>) -> Bool {
    guard case let .object(d) = lhs else { return false }
    return d == rhs
}

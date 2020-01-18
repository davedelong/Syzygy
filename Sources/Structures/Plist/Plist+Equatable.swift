//
//  Plist+Equatable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension Plist: Equatable {

    public static func ==(lhs: Plist, rhs: Plist) -> Bool {
        switch (lhs, rhs) {
            case (.unknown, .unknown): return true
            case (.string(let l), .string(let r)): return l == r
            case (.date(let l), .date(let r)): return l == r
            case (.data(let l), .data(let r)): return l == r
            case (.integer(let l), .integer(let r)): return l == r
            case (.number(let l), .number(let r)): return l == r
            case (.boolean(let l), .boolean(let r)): return l == r
            case (.array(let l), .array(let r)): return l == r
            case (.dictionary(let l), .dictionary(let r)): return l == r
            default: return false
        }
    }

    public static func ==(lhs: Plist, rhs: String) -> Bool {
        return lhs.string == rhs
    }

    public static func ==(lhs: Plist, rhs: Date) -> Bool {
        return lhs.date == rhs
    }

    public static func ==(lhs: Plist, rhs: Data) -> Bool {
        return lhs.data == rhs
    }

    public static func ==(lhs: Plist, rhs: Int) -> Bool {
        return lhs.integer == rhs
    }

    public static func ==(lhs: Plist, rhs: Double) -> Bool {
        return lhs.number == rhs
    }

    public static func ==(lhs: Plist, rhs: Bool) -> Bool {
        return lhs.bool == rhs
    }

    public static func ==(lhs: Plist, rhs: Array<Plist>) -> Bool {
        guard case let .array(a) = lhs else { return false }
        return a == rhs
    }

    public static func ==(lhs: Plist, rhs: Dictionary<String, Plist>) -> Bool {
        guard case let .dictionary(d) = lhs else { return false }
        return d == rhs
    }

}


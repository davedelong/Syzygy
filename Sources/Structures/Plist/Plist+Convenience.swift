//
//  Plist+Convenience.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Plist {
    var isUnknown: Bool { return self == .unknown }
    var isString: Bool { return self.string != nil }
    var isDate: Bool { return self.date != nil }
    var isData: Bool { return self.data != nil }
    var isInteger: Bool { return self.integer != nil }
    var isNumber: Bool { return self.number != nil }
    var isDictionary: Bool { return self.dictionary != nil }
    var isArray: Bool { return self.array != nil }
    var isBool: Bool { return self.bool != nil }
    
    var string: String? {
        guard case let .string(str) = self else { return nil }
        return str
    }
    
    var date: Date? {
        guard case let .date(d) = self else { return nil }
        return d
    }
    
    var data: Data? {
        guard case let .data(d) = self else { return nil }
        return d
    }
    
    var integer: Int? {
        guard case let .integer(i) = self else { return nil }
        return i
    }
    
    var number: Double? {
        guard case let .number(num) = self else { return nil }
        return num
    }
    
    var bool: Bool? {
        guard case let .boolean(b) = self else { return nil }
        return b
    }
    
    var array: Array<Plist>? {
        guard case let .array(arr) = self else { return nil }
        return arr
    }
    
    var dictionary: Dictionary<String, Plist>? {
        guard case let .dictionary(dict) = self else { return nil }
        return dict
    }
}

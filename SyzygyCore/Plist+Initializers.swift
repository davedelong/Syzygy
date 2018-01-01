//
//  Plist+Initializers.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Plist {
    init(_ value: String) { self = .string(value) }
    init(_ value: Date) { self = .date(value) }
    init(_ value: Data) { self = .data(value) }
    init(_ value: Int) { self = .integer(value) }
    init(_ value: Double) { self = .number(value) }
    init(_ value: Bool) { self = .boolean(value) }
    init(_ value: Array<Plist>) { self = .array(value) }
    init(_ value: Dictionary<String, Plist>) { self = .dictionary(value) }
    
    init?<T>(_ value: T?) {
        guard let value = value else { return nil }
        self.init(value)
    }
    
    init(_ value: Any) {
        
        switch value {
            case let str as String:
                self = .string(str)
            
            case let date as Date:
                self = .date(date)
                
            case let data as Data:
                self = .data(data)
            
            case let bool as Bool:
                self = .boolean(bool)
            
            case let num as NSNumber:
                let objcType = String(cString: num.objCType)
                switch objcType {
                    case "c" where num.intValue == 0 || num.intValue == 1: fallthrough
                    case "B":
                        self = .boolean(num.boolValue)
                    
                    case "f": fallthrough
                    case "g":
                        self = .number(num.doubleValue)
                    
                    case "c": fallthrough
                    case "i": fallthrough
                    case "s": fallthrough
                    case "l": fallthrough
                    case "q": fallthrough
                    case "C": fallthrough
                    case "I": fallthrough
                    case "S": fallthrough
                    case "L": fallthrough
                    case "Q":
                        self = .integer(num.intValue)
                    
                    default:
                        self = .unknown
                    }
            
            case let int as Int:
                self = .integer(int)
            
            case let dbl as Double:
                self = .number(dbl)
            
            case let arr as Array<Plist>:
                self = .array(arr)
            
            case let dict as Dictionary<String, Plist>:
                self = .dictionary(dict)
            
            case let arr as Array<Any>:
                self = .array(arr.map { Plist($0) })
            
            case let dict as Dictionary<String, Any>:
                self = .dictionary(dict.map { ($0, Plist($1)) })
            
            default:
                self = .unknown
        }
    }
    
}

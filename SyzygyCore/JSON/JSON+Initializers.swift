//
//  JSON+Initializers.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension JSON {
    init(_ value: String) { self = .string(value) }
    init(_ value: Int) { self = .number(Double(value)) }
    init(_ value: Double) { self = .number(value) }
    init(_ value: Dictionary<String, JSON>) { self = .object(value) }
    init(_ value: Array<JSON>) { self = .array(value) }
    init(_ value: Bool) { self = .boolean(value) }
    
    init<T: OptionalType>(_ value: T) {
        if let o = value.optionalValue {
            self.init(o)
        } else {
            self.init(nilLiteral: ())
        }
    }
    
    init(_ value: Any) {
        
        switch value {
            case let str as String:
                self = .string(str)
                
            case let num as NSNumber:
                if String(cString: num.objCType) == "c" { //may be Bool value
                    self = .boolean(num.boolValue)
                } else {
                    self = .number(num.doubleValue)
                }
                
            case let arr as Array<JSON>:
                self = .array(arr)
                
            case let dict as Dictionary<String, JSON>:
                self = .object(dict)
                
            case let arr as Array<Any>:
                self = .array(arr.map { JSON($0) })
                
            case let dict as Dictionary<String, Any>:
                self = .object(dict.map { ($0, JSON($1)) })
                
            case _ as NSNull:
                self = .null
                
            default:
                self = .unknown
        }
    }
    
}

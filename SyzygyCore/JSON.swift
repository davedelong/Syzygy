//
//  JSON.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public enum JSON {
    
    public enum Kind {
        case unknown
        case null, string, number, boolean, array, object
    }
    
    case unknown
    case null
    case string(String)
    case number(Double)
    case boolean(Bool)
    case array(Array<JSON>)
    case object(Dictionary<String, JSON>)
    
    public var kind: Kind {
        switch self {
            case .unknown: return .unknown
            case .null: return .null
            case .string(_): return .string
            case .number(_): return .number
            case .boolean(_): return .boolean
            case .array(_): return .array
            case .object(_): return .object
        }
    }
}

extension JSON {
    
    var jsonTypeDescription: String {
        switch self {
            case .unknown: return "Unknown"
            case .null: return "Null"
            case .string(_): return "String"
            case .number(_): return "Number"
            case .boolean(_): return "Boolean"
            case .array(_): return "Array"
            case .object(_): return "Object"
        }
    }
    
}

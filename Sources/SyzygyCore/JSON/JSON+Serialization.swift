//
//  JSON+Serialization.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension JSON {
    
    public init(contentsOf path: AbsolutePath) throws {
        let data = try Data(contentsOf: path.fileURL, options: [])
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        self.init(object)
    }
    
    public func data(_ options: JSONSerialization.WritingOptions = []) throws -> Data {
        let o = try jsonObject()
        return try JSONSerialization.data(withJSONObject: o, options: options)
    }
    
    public func jsonObject() throws -> Any {
        switch self {
            case .unknown: throw JSONError.unknownJSON()
            case .null: return NSNull()
            case .string(let s): return s
            case .number(let n): return n
            case .boolean(let b): return b
            case .array(let a): return try a.map { try $0.jsonObject() }
            case .object(let d): return try d.mapValues { try $0.jsonObject() }
        }
    }
    
    public func jsonString(_ options: JSONSerialization.WritingOptions = [.prettyPrinted]) throws -> String {
        let d = try data(options)
        return try String(data: d, encoding: .utf8) ?! JSONError.serializationError()
    }
    
}

//
//  JSON+JSONInitializable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

    public extension JSON {
        
        public func value<T: JSONInitializable>(for key: String, path: String? = nil) throws -> T {
            let o = try self.object ?! JSONError.wrongKind(self, expected: .object)
        
        let newPath = path.map { $0.isEmpty ? key : "\($0)[\(key)]" } ?? key
        let json = try o[key] ?! JSONError.object(self, missing: key)
        return try T.init(path: newPath, json: json)
    }
    
    public func value<T: JSONInitializable>(for key: String, path: String? = nil) throws -> T? {
        let o = try self.object ?! JSONError.wrongKind(self, expected: .object)
        
        let newPath = path.map { $0.isEmpty ? key : "\($0)[\(key)]" } ?? key
        guard let json = o[key] else { return nil }
        return try T.init(path: newPath, json: json)
    }
    
    public func value<T: JSONInitializable>(for key: String, path: String? = nil) throws -> Array<T> {
        let o = try self.object ?! JSONError.wrongKind(self, expected: .object)
        
        let newPath = path.map { $0.isEmpty ? key : "\($0)[\(key)]" } ?? key
        let json = try o[key] ?! JSONError.object(self, missing: key)
        let array = try json.array ?! JSONError.wrongKind(json, expected: .array)
        
        let mapped = try array.enumerated().map { (index, j) -> T in
            return try T.init(path: "\(newPath)[\(index)]", json: j)
        }
        return mapped
    }
    
    public func value<T: JSONInitializable>(for key: String, path: String? = nil) throws -> Array<T>? {
        let o = try self.object ?! JSONError.wrongKind(self, expected: .object)
        
        let newPath = path.map { $0.isEmpty ? key : "\($0)[\(key)]" } ?? key
        guard let json = o[key] else { return nil }
        let array = try json.array ?! JSONError.wrongKind(json, expected: .array) 
        let mapped = try array.enumerated().map { (index, j) -> T in
            return try T.init(path: "\(newPath)[\(index)]", json: j)
        }
        return mapped
    }
    
}

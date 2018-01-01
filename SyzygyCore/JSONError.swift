//
//  JSONError.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public struct JSONError: Error {
    
    public static func unknownJSON(_ file: StaticString = #file, _ line: UInt = #line) -> JSONError {
        return JSONError(message: "Attempting to manipulate an unknown/invalid JSON value", file: file, line: line)
    }
    
    public static func wrongKind(_ json: JSON, expected: JSON.Kind, _ file: StaticString = #file, _ line: UInt = #line) -> JSONError {
        let message = "JSON value \(json) is not a \(expected)"
        return JSONError(message: message, file: file, line: line)
    }
    
    public static func object(_ json: JSON, missing key: String, _ file: StaticString = #file, _ line: UInt = #line) -> JSONError {
        let message = "JSON object \(json) is missing key '\(key)'"
        return JSONError(message: message, file: file, line: line)
    }
    
    public static func array(_ json: JSON, missing index: Int, _ file: StaticString = #file, _ line: UInt = #line) -> JSONError {
        let message = "JSON array \(json) is missing index \(index)"
        return JSONError(message: message, file: file, line: line)
    }
    
    public static func cannotInitialize<T: JSONInitializable>(_ type: T.Type, from json: JSON, _ file: StaticString = #file, _ line: UInt = #line) -> JSONError {
        let message = "Cannot create instance of \(type) from JSON \(json)"
        return JSONError(message: message, file: file, line: line)
    }
    
    public let file: StaticString
    public let line: UInt
    public let message: String
    
    private init(message: String, file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
        self.message = message
    }
    
}

public enum JSONError_old: Error {
    case unknownJSON
    case invalidReceiver(String)
    case missingValue(String)
    case invalidValue(String)
    
    public init(invalid: JSON, key: String) {
        self = .invalidReceiver("Invalid receiver \(invalid) attempting to access key \(key)")
    }
    
    public init(_ path: String? = nil, missing: String) {
        var m = "Missing value for key "
        if let path = path {
            m += path + "[" + missing + "]"
        } else {
            m += missing
        }
        self = .missingValue(m)
    }
    
    public init(path: String, value: JSON) {
        let m = "Invalid value for key \(path): \(value)"
        self = .invalidValue(m)
    }
    
}

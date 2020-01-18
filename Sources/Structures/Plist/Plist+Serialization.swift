//
//  Plist+Serialization.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Paths

extension Plist.Format {
    
    fileprivate var rawFormatValue: PropertyListSerialization.PropertyListFormat {
        switch self {
            case .xml: return .xml
            case .binary: return .binary
            case .openStep: return .openStep
        }
    }
    
}

extension Plist {
    
    public init(contentsOf path: AbsolutePath) throws {
        let data = try Data(contentsOf: path.fileURL, options: [])
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        let object = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        self.init(object)
    }
    
    public func plistData(_ format: Plist.Format = .xml) throws -> Data {
        let o = try plistObject()
        return try PropertyListSerialization.data(fromPropertyList: o, format: format.rawFormatValue, options: 0)
    }
    
    public func plistObject() throws -> Any {
        switch self {
            case .unknown: throw Plist.Error("Cannot encode a Plist value of \"Unknown\"")
            case .string(let s): return s
            case .date(let d): return d
            case .data(let d): return d
            case .integer(let i): return i
            case .number(let n): return n
            case .boolean(let b): return b
            case .array(let a): return try a.map { try $0.plistObject() }
            case .dictionary(let d): return try d.mapValues { try $0.plistObject() }
        }
    }
    
    public func write(to path: AbsolutePath, format: Plist.Format = .xml, options: Data.WritingOptions = [.atomic]) throws {
        let obj = try self.plistData(format)
        let fm = FileManager.default
        if fm.fileExists(atPath: path) == false {
            fm.createFile(atPath: path)
        }
        try obj.write(to: path.fileURL, options: options)
    }
    
}

//
//  Plist.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public enum Plist {
    case unknown
    
    case string(String)
    case date(Date)
    case data(Data)
    case integer(Int)
    case number(Double)
    case boolean(Bool)
    
    case array(Array<Plist>)
    case dictionary(Dictionary<String, Plist>)
    
    public enum Format {
        case xml
        case binary
        case openStep
    }
    
    public struct Error: Swift.Error {
        public let message: String
        public init(_ message: String) {
            self.message = message
        }
    }
    
}

public protocol PlistConvertible {
    var plistValue: Plist { get }
    init?(_ plist: Plist?)
}

extension String: PlistConvertible {
    public var plistValue: Plist { return .string(self) }
    public init?(_ plist: Plist?) {
        guard let v = plist?.string else { return nil }
        self = v
    }
}

extension Date: PlistConvertible {
    public var plistValue: Plist { return .date(self) }
    public init?(_ plist: Plist?) {
        guard let v = plist?.date else { return nil }
        self = v
    }
}

extension Data: PlistConvertible {
    public var plistValue: Plist { return .data(self) }
    public init?(_ plist: Plist?) {
        guard let v = plist?.data else { return nil }
        self = v
    }
}

extension Int: PlistConvertible {
    public var plistValue: Plist { return .integer(self) }
    public init?(_ plist: Plist?) {
        guard let v = plist?.integer else { return nil }
        self = v
    }
}

extension Double: PlistConvertible {
    public var plistValue: Plist { return .number(self) }
    public init?(_ plist: Plist?) {
        guard let v = plist?.number else { return nil }
        self = v
    }
}

extension Bool: PlistConvertible {
    public var plistValue: Plist { return .boolean(self) }
    public init?(_ plist: Plist?) {
        guard let v = plist?.bool else { return nil }
        self = v
    }
}

//
//  Plist+Convertible.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

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

public extension Plist {
    
    public func value<T: PlistConvertible>(for key: String) -> T? {
        guard let d = self.dictionary else { return nil }
        guard let plist = d[key] else { return nil }
        return T.init(plist)
    }
    
    public func value<T: PlistConvertible>(for key: String) -> Array<T>? {
        guard let d = self.dictionary else { return nil }
        guard let array = d[key]?.array else { return nil }
        return array.compactMap { T.init($0) }
    }
    
}

//
//  Identifier.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public typealias Map<T, V: Hashable> = Dictionary<Identifier<T, V>, T>
public typealias IdentifierSet<T, V: Hashable> = Set<Identifier<T, V>>

public struct Identifier<T, Value>: Newtype {
    public let rawValue: Value
    
    public init(rawValue: Value) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: Value) {
        self.rawValue = rawValue
    }
}

extension Identifier: Equatable where Value: Equatable { }
extension Identifier: Hashable where Value: Hashable { }
extension Identifier: Codable where Value: Codable { }

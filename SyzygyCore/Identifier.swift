//
//  Identifier.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public typealias Map<T: Identifiable> = Dictionary<T.ID, T>
public typealias IdentifierSet<T: Identifiable> = Set<T.ID>

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

public protocol Identifiable {
    associatedtype IdentifiedType = Self
    associatedtype IdentifierType: Hashable = String
    
    typealias ID = Identifier<IdentifiedType, IdentifierType>
    var identifier: ID { get }
}

public extension Identifiable {
    var id: ID { return identifier }
}

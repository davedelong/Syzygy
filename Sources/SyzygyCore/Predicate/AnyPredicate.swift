//
//  AnyPredicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct AnyPredicate<E>: Predicate {
    
    public static var `true`: AnyPredicate<E> { return AnyPredicate { _ in return true } }
    public static var `false`: AnyPredicate<E> { return AnyPredicate { _ in return false } }
    
    private let predicate: (E) -> Bool
    
    public init(_ predicate: @escaping (E) -> Bool) {
        self.predicate = predicate
    }
    
    public init<P: Predicate>(_ predicate: P) where P.Element == E {
        self.predicate = { predicate.contains($0) }
    }
    
    public func contains(_ value: E) -> Bool {
        return self.predicate(value)
    }
    
}

//
//  OrPredicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct OrPredicate<E>: Predicate {
    
    private let subpredicates: Array<(E) -> Bool>
    
    public init<C: Collection>(_ predicates: C) where C.Element: Predicate, C.Element.Element == E {
        self.subpredicates = predicates.map { f -> ((E) -> Bool) in
            return { f.contains($0) }
        }
    }
    
    public init(_ lhs: OrPredicate<E>, _ rhs: OrPredicate<E>) {
        self.subpredicates = lhs.subpredicates + rhs.subpredicates
    }
    
    public init<P: Predicate>(_ lhs: P, _ rhs: OrPredicate<E>) where P.Element == E {
        self.subpredicates = [
            { lhs.contains($0) }
        ] + rhs.subpredicates
    }
    
    public init<P: Predicate>(_ lhs: OrPredicate<E>, _ rhs: P) where P.Element == E {
        self.subpredicates = lhs.subpredicates + [
            { rhs.contains($0) }
        ]
    }
    
    public init<P1: Predicate, P2: Predicate>(_ f1: P1, _ f2: P2) where P1.Element == E, P2.Element == E {
        self.subpredicates = [
            { f1.contains($0) },
            { f2.contains($0) },
        ]
    }
    
    public func contains(_ value: E) -> Bool {
        for matcher in subpredicates {
            if matcher(value) == true { return true }
        }
        return false
    }
    
}

public extension Predicate {
    
    static func ||<P: Predicate>(lhs: Self, rhs: P) -> OrPredicate<Element> where P.Element == Element {
        return OrPredicate(lhs, rhs)
    }
    
    static func ||(lhs: Self, rhs: OrPredicate<Element>) -> OrPredicate<Element> {
        return OrPredicate(lhs, rhs)
    }
    
    static func ||(lhs: OrPredicate<Element>, rhs: Self) -> OrPredicate<Element> {
        return OrPredicate(lhs, rhs)
    }
    
}

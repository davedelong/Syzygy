//
//  XorPredicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct XorPredicate<E>: Predicate {
    
    private let subpredicates: Array<(E) -> Bool>
    
    public init<C: Collection>(_ predicates: C) where C.Element: Predicate, C.Element.Element == E {
        self.subpredicates = predicates.map { f -> ((E) -> Bool) in
            return { f.contains($0) }
        }
    }
    
    public init(_ lhs: XorPredicate<E>, _ rhs: XorPredicate<E>) {
        self.subpredicates = lhs.subpredicates + rhs.subpredicates
    }
    
    public init<P: Predicate>(_ lhs: P, _ rhs: XorPredicate<E>) where P.Element == E {
        self.subpredicates = [
            { lhs.contains($0) }
        ] + rhs.subpredicates
    }
    
    public init<P: Predicate>(_ lhs: XorPredicate<E>, _ rhs: P) where P.Element == E {
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
        var anyMatcherContains = false
        
        for matcher in subpredicates {
            let thisMatcherContains = matcher(value)
            
            // only one matcher is allowed to contain this value
            if thisMatcherContains && anyMatcherContains { return false }
            
            anyMatcherContains = thisMatcherContains
        }
        
        return anyMatcherContains
    }
    
}

public extension Predicate {
    
    public static func ^<P: Predicate>(lhs: Self, rhs: P) -> XorPredicate<Element> where P.Element == Element {
        return XorPredicate(lhs, rhs)
    }
    
    public static func ^(lhs: Self, rhs: XorPredicate<Element>) -> XorPredicate<Element> {
        return XorPredicate(lhs, rhs)
    }
    
    public static func ^(lhs: XorPredicate<Element>, rhs: Self) -> XorPredicate<Element> {
        return XorPredicate(lhs, rhs)
    }
    
}

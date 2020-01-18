//
//  Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol Predicate {
    associatedtype Element
    
    func contains(_ value: Element) -> Bool
}

public extension Predicate {
    
    var inverted: NotPredicate<Element> { return NotPredicate(self) }
    
    func union<P: Predicate>(_ other: P) -> OrPredicate<Element> where P.Element == Element {
        return OrPredicate(self, other)
    }
    
    func intersection<P: Predicate>(_ other: P) -> AndPredicate<Element> where P.Element == Element {
        return AndPredicate(self, other)
    }
    
    func symmetricDifference<P: Predicate>(_ other: P) -> XorPredicate<Element> where P.Element == Element {
        return XorPredicate(self, other)
    }
    
    func subtracting<P: Predicate>(_ other: P) -> AnyPredicate<Element> where P.Element == Element {
        return AnyPredicate(self && !other)
    }
    
    func and<P: Predicate>(_ other: P) -> AndPredicate<Element> where P.Element == Element {
        return intersection(other)
    }
    
    func or<P: Predicate>(_ other: P) -> OrPredicate<Element> where P.Element == Element {
        return union(other)
    }
    
    func xor<P: Predicate>(_ other: P) -> XorPredicate<Element> where P.Element == Element {
        return symmetricDifference(other)
    }
    
    func minus<P: Predicate>(_ other: P) -> AnyPredicate<Element> where P.Element == Element {
        return subtracting(other)
    }
    
}

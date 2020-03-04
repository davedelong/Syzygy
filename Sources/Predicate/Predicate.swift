//
//  Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import StandardLibrary

public struct Predicate<Element> {
    public let contains: (Element) -> Bool
    
    public init(_ predicate: @escaping (Element) -> Bool) {
        self.contains = predicate
    }
}

public extension Predicate {
    
    var inverted: Predicate {
        return Predicate({ self.contains($0) == false })
    }
    
    mutating func invert() {
        self = inverted
    }
    
    func union(_ other: Predicate) -> Predicate {
        Predicate {
            self.contains($0) || other.contains($0)
        }
    }
    
    mutating func formUnion(_ other: Predicate) {
        self = self.union(other)
    }
    
    func intersection(_ other: Predicate) -> Predicate {
        Predicate {
            self.contains($0) && other.contains($0)
        }
    }
    
    mutating func formIntersection(_ other: Predicate) {
        self = self.intersection(other)
    }
    
    func symmetricDifference(_ other: Predicate) -> Predicate {
        Predicate {
            (self.contains($0) && !other.contains($0)) ||
            (other.contains($0) && !self.contains($0))
        }
    }
    
    mutating func formSymmetricDifference(_ other: Predicate) {
        self = self.symmetricDifference(other)
    }
    
    func subtracting(_ other: Predicate) -> Predicate {
        Predicate {
            self.contains($0) && !other.contains($0)
        }
    }
    
    mutating func subtract(_ other: Predicate) {
        self = self.subtracting(other)
    }
    
    func and(_ other: Predicate) -> Predicate { intersection(other) }
    func or(_ other: Predicate) -> Predicate { union(other) }
    func xor(_ other: Predicate) -> Predicate { symmetricDifference(other) }
    func minus(_ other: Predicate) -> Predicate { subtracting(other) }
    
}

public extension Predicate {
    
    static func && (lhs: Predicate, rhs: Predicate) -> Predicate { lhs.and(rhs) }
    static func || (lhs: Predicate, rhs: Predicate) -> Predicate { lhs.and(rhs) }
    static func ^ (lhs: Predicate, rhs: Predicate) -> Predicate { lhs.xor(rhs) }
    static prefix func ! (rhs: Predicate) -> Predicate { rhs.inverted }
    
    static var `true`: Predicate { Predicate({ _ in true }) }
    static var `false`: Predicate { Predicate({ _ in false }) }
    
}

public extension Predicate {
    
    static func and<C: Collection>(_ subpredicates: C) -> Predicate where C.Element == Predicate {
        Predicate { element in
            return subpredicates.allSatisfy({ $0.contains(element) })
        }
    }
    
    static func or<C: Collection>(_ subpredicates: C) -> Predicate where C.Element == Predicate {
        Predicate { element in
            let match = subpredicates.first(where: { $0.contains(element) })
            return match != nil
        }
    }
    
    static func xor<C: Collection>(_ subpredicates: C) -> Predicate where C.Element == Predicate {
        Predicate { element in
            var count = 0
            for subpredicate in subpredicates {
                if subpredicate.contains(element) {
                    count += 1
                }
                if count > 1 { break }
            }
            return count == 1
        }
    }
    
}

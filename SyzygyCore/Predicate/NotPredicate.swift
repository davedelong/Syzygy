//
//  NotPredicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct NotPredicate<E>: Predicate {
    
    private let predicate: (E) -> Bool
    
    public init<P: Predicate>(_ predicate: P) where P.Element == Element {
        self.predicate = { !predicate.contains($0) }
    }
    
    public func contains(_ value: E) -> Bool {
        return predicate(value)
    }
    
}

extension Predicate {
    public static prefix func -(value: Self) -> NotPredicate<Element> {
        return NotPredicate(value)
    }
    public static prefix func !(value: Self) -> NotPredicate<Element> {
        return NotPredicate(value)
    }
}

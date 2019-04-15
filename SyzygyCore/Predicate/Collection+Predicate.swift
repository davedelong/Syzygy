//
//  Collection+Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Collection {
    
    func filter<P: Predicate>(by predicate: P) -> Array<Element> where P.Element == Element {
        return filter(predicate.contains(_:))
    }
    
    func every<P: Predicate>(_ predicate: P) -> Bool where P.Element == Element {
        return all(predicate)
    }
    
    func all<P: Predicate>(_ predicate: P) -> Bool where P.Element == Element {
        return all(predicate.contains(_:))
    }
    
    func any<P: Predicate>(_ predicate: P) -> Bool where P.Element == Element {
        return any(predicate.contains(_:))
    }
    
    func none<P: Predicate>(_ predicate: P) -> Bool where P.Element == Element {
        return none(predicate.contains(_:))
    }
    
    func divide<P: Predicate>(_ isInFirst: P) -> (Array<Element>, Array<Element>) where P.Element == Element {
        return divide(isInFirst.contains(_:))
    }
    
}



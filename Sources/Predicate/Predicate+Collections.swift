//
//  Collection+Predicate.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import StandardLibrary

public extension Collection {
    
    func filter(by predicate: Predicate<Element>) -> Array<Element> {
        return filter(predicate.contains)
    }
    
    func every(_ predicate: Predicate<Element>) -> Bool {
        return all(predicate)
    }
    
    func all(_ predicate: Predicate<Element>) -> Bool {
        return all(predicate.contains)
    }
    
    func any(_ predicate: Predicate<Element>) -> Bool {
        return any(predicate.contains)
    }
    
    func none(_ predicate: Predicate<Element>) -> Bool {
        return none(predicate.contains)
    }
    
    func divide(_ isInFirst: Predicate<Element>) -> (Array<Element>, Array<Element>) {
        return divide(isInFirst.contains)
    }
    
}

public extension Set {
    
    func filter(by predicate: Predicate<Element>) -> Set<Element> {
        return self.filter(predicate.contains)
    }
    
}



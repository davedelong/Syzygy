//
//  Set.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Set {
    
    func filter<P: Predicate>(by predicate: P) -> Set<Element> where P.Element == Element {
        return self.filter(predicate.contains(_:))
    }
    
}

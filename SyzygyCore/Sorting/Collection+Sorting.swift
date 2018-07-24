//
//  Collection+Sorting.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Sequence {
    
    public func sorted<S: Sorting>(by sorter: S) -> Array<Element> where S.Base == Element {
        return sorted(by: sorter.orders(_:before:))
    }
    
}

extension MutableCollection where Self: RandomAccessCollection {
    
    public mutating func sort<S: Sorting>(by sorter: S) where S.Base == Element {
        sort(by: sorter.orders(_:before:))
    }
    
}

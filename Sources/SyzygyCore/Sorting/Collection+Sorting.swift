//
//  Collection+Sorting.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import StandardLibrary

public extension Sequence {
    
    func sorted<S: Sorting>(by sorter: S) -> Array<Element> where S.Base == Element {
        return sorted(by: sorter.orders(_:before:))
    }
    
    func sorted<C: Collection>(by sorters: C) -> Array<Element> where C.Element: Sorting, C.Element.Base == Element {
        let combined = CombinedSorter(sorters)
        return sorted(by: combined)
    }
    
}

public extension Collection where Element: NSObjectProtocol {
    
    func sorted(by descriptors: Array<NSSortDescriptor>) -> Array<Element> {
        guard descriptors.isNotEmpty else { return Array(self) }
        return self.sorted(by: { (left, right) -> Bool in
            for d in descriptors {
                if d.orders(left, before: right) { return true }
            }
            return false
        })
    }
    
}

extension MutableCollection where Self: RandomAccessCollection {
    
    public mutating func sort<S: Sorting>(by sorter: S) where S.Base == Element {
        sort(by: sorter.orders(_:before:))
    }
    
    public mutating func sort<C: Collection>(by sorters: C) where C.Element: Sorting, C.Element.Base == Element {
        let combined = CombinedSorter(sorters)
        sort(by: combined)
    }
    
}

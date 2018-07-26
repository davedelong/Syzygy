//
//  CombinedSorter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct CombinedSorter<B>: Sorting {
    private let sorters: Array<(B, B) -> Bool>
    
    public init<C: Collection>(_ sorters: C) where C.Element: Sorting, C.Element.Base == B {
        self.sorters = sorters.map { s -> ((B, B) -> Bool) in
            return { s.orders($0, before: $1) }
        }
    }
    
    public init<S1: Sorting, S2: Sorting>(_ s1: S1, _ s2: S2) where S1.Base == B, S2.Base == B {
        sorters = [
            { s1.orders($0, before: $1) },
            { s2.orders($0, before: $1) }
        ]
    }
    
    public init<S1: Sorting, S2: Sorting, S3: Sorting>(_ s1: S1, _ s2: S2, _ s3: S3)
        where S1.Base == B, S2.Base == B, S3.Base == B {
            
        sorters = [
            { s1.orders($0, before: $1) },
            { s2.orders($0, before: $1) },
            { s3.orders($0, before: $1) }
        ]
    }
    
    public init<S1: Sorting, S2: Sorting, S3: Sorting, S4: Sorting>(_ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4)
        where S1.Base == B, S2.Base == B, S3.Base == B, S4.Base == B {
            
            sorters = [
                { s1.orders($0, before: $1) },
                { s2.orders($0, before: $1) },
                { s3.orders($0, before: $1) },
                { s4.orders($0, before: $1) }
            ]
    }
    
    public init<S1: Sorting, S2: Sorting, S3: Sorting, S4: Sorting, S5: Sorting>(_ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5)
        where S1.Base == B, S2.Base == B, S3.Base == B, S4.Base == B, S5.Base == B {
            
            sorters = [
                { s1.orders($0, before: $1) },
                { s2.orders($0, before: $1) },
                { s3.orders($0, before: $1) },
                { s4.orders($0, before: $1) },
                { s5.orders($0, before: $1) }
            ]
    }
    
    public func orders(_ left: B, before: B) -> Bool {
        for sorter in sorters {
            if sorter(left, before) { return true }
            if sorter(before, left) { return false }
        }
        return true
    }
    
}

public extension Sorting {
    
    public static func +<S: Sorting>(lhs: Self, rhs: S) -> CombinedSorter<Base> where S.Base == Base {
        return CombinedSorter(lhs, rhs)
    }
    
    public func combine<S1: Sorting>(_ s1: S1) -> CombinedSorter<Base> where S1.Base == Base {
        return CombinedSorter(self, s1)
    }
    
    public func combine<S1: Sorting, S2: Sorting>(_ s1: S1, _ s2: S2) -> CombinedSorter<Base>
        where S1.Base == Base, S2.Base == Base {
            
        return CombinedSorter(self, s1, s2)
    }
    
    public func combine<S1: Sorting, S2: Sorting, S3: Sorting>(_ s1: S1, _ s2: S2, _ s3: S3) -> CombinedSorter<Base>
        where S1.Base == Base, S2.Base == Base, S3.Base == Base {
            
            return CombinedSorter(self, s1, s2, s3)
    }
    
    public func combine<S1: Sorting, S2: Sorting, S3: Sorting, S4: Sorting>(_ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4) -> CombinedSorter<Base>
        where S1.Base == Base, S2.Base == Base, S3.Base == Base, S4.Base == Base {
            
            return CombinedSorter(self, s1, s2, s3, s4)
    }
}

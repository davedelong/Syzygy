//
//  RangeReplaceableCollection.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 6/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension RangeReplaceableCollection {
    
    /// Remove and return the first element of the collection, if it exists.
    ///
    /// This exists for subsequence collections, but not for collections themselves.
    ///
    /// Complexity: O(*n*), suckers
    public mutating func popFirst() -> Element? {
        guard self.isEmpty == false else { return nil }
        return removeFirst()
    }
    
}

public extension RangeReplaceableCollection where Element: Equatable {
    
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        guard let index = firstIndex(of: element) else { return false }
        self.remove(at: index)
        return true
    }
    
}

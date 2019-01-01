//
//  Property+Diffs.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/28/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Property where T: RangeReplaceableCollection, T.Element: Differentiable {
    
    public func diffingPrevious() -> Property<(T, StagedChangeset<T>)> {
        let initial = T.init()
        let current = self.value
        let startingDiff = initial.difference(to: current)
        
        let m = MutableProperty((current, startingDiff))
        
        observeNext { new in
            m.potentiallyModifyValue { (collection, diff) in
                let newDiff = collection.difference(to: new)
                return (new, newDiff)
            }
        }
        
        return m
    }
    
}

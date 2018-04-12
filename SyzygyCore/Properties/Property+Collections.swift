//
//  Property+Collections.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property where T: Collection {
    
    public func mapItems<U>(_ mapper: @escaping (T.Element) -> U) -> Property<Array<U>> {
        return map { $0.map(mapper) }
    }
    
    public func compactMapItems<U>(_ mapper: @escaping (T.Element) -> U?) -> Property<Array<U>> {
        return map { $0.compactMap(mapper) }
    }
    
    public func flatMapItems<U>(_ mapper: @escaping (T.Element) -> Array<U>) -> Property<Array<U>> {
        return map { $0.flatMap(mapper) }
    }
    
    public func combineFlatMapItems<U>(_ mapper: @escaping (T.Element) -> Property<U>) -> Property<Array<U>> {
        let combiner: (T) -> Property<Array<U>> = { items in
            let properties = items.map(mapper)
            return Property<U>.combine(properties)
        }
        
        let mirrored = MirroredProperty(mirroring: combiner(value))
        observeNext {
            mirrored.takeValue(from: combiner($0))
        }
        return mirrored
    }
    
    public func combineFlatMapItems<U>(_ mapper: @escaping (T.Element) -> Property<Array<U>>) -> Property<Array<U>> {
        let combiner: (T) -> Property<Array<U>> = { items in
            let properties = items.map(mapper)
            let combined = Property<Array<U>>.combine(properties)
            return combined.map { $0.flatMap { $0 } }
        }
        
        let mirrored = MirroredProperty(mirroring: combiner(value))
        observeNext {
            mirrored.takeValue(from: combiner($0))
        }
        return mirrored
    }
    
    public func filterItems(_ f: @escaping (T.Element) -> Bool) -> Property<Array<T.Element>> {
        return map { $0.filter(f) }
    }
    
}

public extension Property where T: Collection, T.Element: Comparable {
    
    public func sorted() -> Property<Array<T.Element>> { return sorted(<) }
    
    public func sorted(_ sorter: @escaping (T.Element, T.Element) -> Bool) -> Property<Array<T.Element>> {
        return map { $0.sorted(by: sorter) }
    }
    
}

public extension Property where T: Collection, T.Element: Hashable {
    
    public func uniquedItems() -> Property<Array<T.Element>> {
        return map { $0.unique() }
    }
    
}

public extension Property where T: Collection, T.Element: DeeplyEquatable {
    
    public func diffingPrevious() -> Property<(Array<T.Element>, (Array<Diff<T.Element>>))> {
        let initial = Array<T.Element>()
        let current = Array(self.value)
        let startingDiff = initial.difference(to: current)
        
        let m = MutableProperty((current, startingDiff))
        
        observeNext { new in
            m.potentiallyModifyValue { (collection, diff) in
                let newDiff = collection.difference(to: new)
                return (Array(new), newDiff)
            }
        }
        
        return m
    }
    
}

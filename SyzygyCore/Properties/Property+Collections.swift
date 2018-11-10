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
    
    public func partition(by goesInFirst: @escaping (T.Element) -> Bool) -> (Property<Array<T.Element>>, Property<Array<T.Element>>) {
        let m1 = MutableProperty<Array<T.Element>>([])
        let m2 = MutableProperty<Array<T.Element>>([])
        
        observe { items in
            var a1 = Array<T.Element>()
            var a2 = Array<T.Element>()
            for i in items {
                if goesInFirst(i) {
                    a1.append(i)
                } else {
                    a2.append(i)
                }
            }
            m1.value = a1
            m2.value = a2
        }
        
        return (m1, m2)
    }
    
}

public extension Property where T: RandomAccessCollection {
    
    public func item(at index: Property<T.Index>) -> Property<T.Element> {
        let m = MutableProperty<T.Element>(self.value[index.value])
        combine(index).observeNext { coll, ind in
            m.value = coll[ind]
        }
        return m
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

public extension Property {
    
    public func includingPrevious() -> Property<(T, T)> {
        var initial = value
        return map { newValue in
            let oldValue = initial
            initial = newValue
            return (oldValue, newValue)
        }
    }
    
}

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

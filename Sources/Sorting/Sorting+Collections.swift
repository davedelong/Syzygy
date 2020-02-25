//
//  File.swift
//  
//
//  Created by Dave DeLong on 2/25/20.
//

import Foundation

public extension Collection {
    
    // apply a Sorter to the Collection
    func sorted(by sorter: Sorter<Element>) -> Array<Element> {
        return self.sorted(by: { lhs, rhs -> Bool in
            let order = sorter.compare(lhs, rhs)
            return order == .ascending
        })
    }
    
    // apply two or more sorters to a collection
    func sorted(by sorter: Sorter<Element>, _ others: Sorter<Element>...) -> Array<Element> {
        sorted(by: [sorter] + others) // convert varargs to array and call the one with array
    }

    // apply zero or more sorters to a collection
    func sorted(by descriptors: Array<Sorter<Element>>) -> Array<Element> {
        let combined = Sorter(descriptors)
        return sorted(by: combined)
    }

    // convenience to sort the collection by a closure
    func sorted<T: Comparable>(by closure: (Element) -> T, direction: SortDirection = .ascending) -> Array<Element> {
        withoutActuallyEscaping(closure) {
            sorted(by: Sorter($0, direction: direction))
        }
    }

    // convenience to sort the collection by an element KeyPath
    func sorted<T: Comparable>(by keyPath: KeyPath<Element,T>, direction: SortDirection = .ascending) -> Array<Element> {
        sorted(by: Sorter(keyPath, direction: direction))
    }
}

public extension MutableCollection where Self: RandomAccessCollection {
    
    mutating func sort(by sorter: Sorter<Element>) {
        self.sort(by: { lhs, rhs -> Bool in
            let order = sorter.compare(lhs, rhs)
            return order == .ascending
        })
    }
    
    // apply two or more sorters to a collection
    mutating func sort(by sorter: Sorter<Element>, _ others: Sorter<Element>...) -> Array<Element> {
        sort(by: [sorter] + others) // convert varargs to array and call the one with array
    }

    // apply zero or more sorters to a collection
    mutating func sort(by descriptors: Array<Sorter<Element>>) -> Array<Element> {
        let combined = Sorter(descriptors)
        return sort(by: combined)
    }

    // convenience to sort the collection by a closure
    mutating func sort<T: Comparable>(by closure: (Element) -> T, direction: SortDirection = .ascending) -> Array<Element> {
        withoutActuallyEscaping(closure) {
            sort(by: Sorter($0, direction: direction))
        }
    }

    // convenience to sort the collection by an element KeyPath
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element,T>, direction: SortDirection = .ascending) -> Array<Element> {
        sort(by: Sorter(keyPath, direction: direction))
    }
    
}

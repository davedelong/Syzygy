//
//  File.swift
//  
//
//  Created by Dave DeLong on 2/25/20.
//

import Foundation

public enum SortDirection {
    case ascending
    case descending
}

public enum SortOrdering {
    case ascending
    case equal
    case descending
}

public struct Sorter<Element> {
    
    public static func ascending<T: Comparable>(_ keyPath: KeyPath<Element,T>) -> Sorter<Element> {
        Sorter(keyPath, direction: .ascending)
    }
    
    public static func descending<T: Comparable>(_ keyPath: KeyPath<Element,T>) -> Sorter<Element> {
        Sorter(keyPath, direction: .descending)
    }
    
    public let compare: (Element, Element) -> SortOrdering
    
    public init(_ comparator: @escaping (Element, Element) -> SortOrdering) {
        self.compare = comparator
    }
    
    public init<T: Comparable>(_ lens: @escaping (Element) -> T, direction: SortDirection = .ascending) {
        self.compare = { lhs, rhs in
            let (l, r) = (lens(lhs), lens(rhs))
            if l < r { return direction == .ascending ? .ascending : .descending }
            if l > r { return direction == .descending ? .descending : .ascending }
            return .equal
        }
    }
    
    public init<T: Comparable>(_ keyPath: KeyPath<Element, T>, direction: SortDirection = .ascending) {
        self.init({ $0[keyPath: keyPath] }, direction: direction)
    }
    
    public init<C: Collection>(_ sorters: C) where C.Element == Sorter<Element> {
        self.compare = { lhs, rhs -> SortOrdering in
            for sorter in sorters {
                let order = sorter.compare(lhs, rhs)
                if order == .equal { continue }
                return order
            }
            return .equal
        }
    }
}

//
//  Collection.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Collection {
    
    var isNotEmpty: Bool { return isEmpty == false }
    
    func every(_ predicate: (Element) -> Bool) -> Bool {
        return all(predicate)
    }
    
    func all(_ predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) == false { return false }
        }
        return true
    }
    
    func any(_ predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) == true { return true }
        }
        return false
    }
    
    func none(_ predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) == true { return false }
        }
        return true
    }
    
    func keyedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Element> {
        var d = Dictionary<T, Element>()
        for item in self {
            if let key = keyer(item) {
                d[key] = item
            }
        }
        return d
    }
    
    func keyedBy<T: Hashable>(_ keyer: (Element) -> Array<T>) -> Dictionary<T, Element> {
        var d = Dictionary<T, Element>()
        for item in self {
            let keys = keyer(item)
            for key in keys {
                d[key] = item
            }
        }
        return d
    }
    
    func groupedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Array<Element>> {
        var d = Dictionary<T, Array<Element>>()
        for item in self {
            if let key = keyer(item) {
                var items = d.removeValue(forKey: key) ?? []
                items.append(item)
                d[key] = items
            }
        }
        return d
    }
    
    func groupedWithNilsBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T?, Array<Element>> {
        var d = Dictionary<T?, Array<Element>>()
        for item in self {
            let key = keyer(item)
            var items = d.removeValue(forKey: key) ?? []
            items.append(item)
            d[key] = items
        }
        return d
    }
    
    func groupedBy<T: Hashable>(_ keyer: (Element) -> Array<T>) -> Dictionary<T, Array<Element>> {
        var d = Dictionary<T, Array<Element>>()
        for item in self {
            let keys = keyer(item)
            for key in keys {
                var items = d.removeValue(forKey: key) ?? []
                items.append(item)
                d[key] = items
            }
        }
        return d
    }
    
    func intersperse(_ separator: Element) -> Array<Element> {
        return intersperse { separator }
    }
    
    func intersperse(_ item: () -> Element) -> Array<Element> {
        var everything = Array<Element>()
        for element in self {
            everything.append(element)
            everything.append(item())
        }
        everything.removeLast()
        return everything
    }
    
    func divide(_ isInFirst: (Element) -> Bool) -> (Array<Element>, Array<Element>) {
        var first = Array<Element>()
        var second = Array<Element>()
        for item in self {
            if isInFirst(item) {
                first.append(item)
            } else {
                second.append(item)
            }
        }
        return (first, second)
    }
    
    func sum<T: Numeric>(_ value: (Element) -> T) -> T {
        var s = T.init(exactly: 0) !! "Unable to create zero of type \(T.self)"
        for item in self {
            s += value(item)
        }
        return s
    }
    
    func compacted<T>() -> Array<T> where Element == Optional<T> {
        return compactMap { $0 }
    }
    
    func sorted<C: Comparable>(ascending: Bool = true, by: (Element) -> C) -> Array<Element> {
        if ascending {
            return sorted(by: { by($0) < by($1) })
        } else {
            return sorted(by: { by($0) > by($1) })
        }
    }
    
    func count(where matches: (Element) -> Bool) -> Int {
        var count = 0
        for item in self {
            if matches(item) { count += 1}
        }
        return count
    }
    
    func chunks(of size: Int) -> ChunkedCollection<Self> {
        return ChunkedCollection(self, size: size)
    }
    
}

public extension Collection where Element: Numeric {
    
    func sum() -> Element {
        var s = Element.init(exactly: 0) !! "Unable to create zero of type \(Element.self)"
        for item in self {
            s += item
        }
        return s
    }
    
}

public extension Collection where Element: Hashable {
    
    func unique() -> Array<Element> {
        var uniqued = Array<Element>()
        var soFar = Set<Element>()
        for item in self {
            if soFar.contains(item) == false {
                uniqued.append(item)
                soFar.insert(item)
            }
        }
        return uniqued
    }
}


public struct ChunkedCollection<Base: Collection>: Collection {
    private let base: Base
    private let chunkSize: Int
    
    public init(_ base: Base, size: Int) {
        self.base = base
        chunkSize = size
    }
    
    public typealias Index = Base.Index
    
    public var startIndex: Index {
        return base.startIndex
    }
    
    public var endIndex: Index {
        return base.endIndex
    }
    
    public func index(after index: Index) -> Index {
        return base.index(index, offsetBy: chunkSize, limitedBy: base.endIndex) ?? base.endIndex
    }
    
    public subscript(index: Index) -> Base.SubSequence {
        return base[index..<self.index(after: index)]
    }
}

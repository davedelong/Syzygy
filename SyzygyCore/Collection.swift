//
//  Collection.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Collection {
    
    public func every(_ predicate: (Element) -> Bool) -> Bool {
        return all(predicate)
    }
    
    public func all(_ predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) == false { return false }
        }
        return true
    }
    
    public func any(_ predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) == true { return true }
        }
        return false
    }
    
    public func none(_ predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) == true { return false }
        }
        return true
    }
    
    public func keyedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Element> {
        var d = Dictionary<T, Element>()
        for item in self {
            if let key = keyer(item) {
                d[key] = item
            }
        }
        return d
    }
    
    public func keyedBy<T: Hashable>(_ keyer: (Element) -> Array<T>) -> Dictionary<T, Element> {
        var d = Dictionary<T, Element>()
        for item in self {
            let keys = keyer(item)
            for key in keys {
                d[key] = item
            }
        }
        return d
    }
    
    public func groupedBy<T: Hashable>(_ keyer: (Element) -> T?) -> Dictionary<T, Array<Element>> {
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
    
    public func groupedBy<T: Hashable>(_ keyer: (Element) -> Array<T>) -> Dictionary<T, Array<Element>> {
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
    
    public func intersperse(_ separator: Element) -> Array<Element> {
        return intersperse { separator }
    }
    
    public func intersperse(_ item: () -> Element) -> Array<Element> {
        var everything = Array<Element>()
        for element in self {
            everything.append(element)
            everything.append(item())
        }
        everything.removeLast()
        return everything
    }
    
    public func divide(_ isInFirst: (Element) -> Bool) -> (Array<Element>, Array<Element>) {
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
    
    public func sum<T: Numeric>(_ value: (Element) -> T) -> T {
        var s = T.init(exactly: 0) !! "Unable to create zero of type \(T.self)"
        for item in self {
            s += value(item)
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

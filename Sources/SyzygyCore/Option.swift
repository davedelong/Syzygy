//
//  Option.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 11/7/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol Option: Hashable {
    associatedtype StableOrderCollection: Collection where Self.StableOrderCollection.Element == Self
    static var stableOrder: StableOrderCollection { get }
}

public extension Option where Self: CaseIterable {
    static var stableOrder: AllCases { return self.allCases }
}

extension Set where Element: Option {
    
    public init?(rawValue: Int) {
        self.init()
        var remaining = rawValue
        for (index, element) in Element.stableOrder.enumerated() {
            let thisBitmask = 1 << index
            guard remaining & thisBitmask == thisBitmask else { continue }
            insert(element)
            remaining -= thisBitmask
            if remaining == 0 { break }
        }
        if remaining != 0 { return nil }
    }
    
    public var rawValue: Int {
        var result = 0
        for (index, element) in Element.stableOrder.enumerated() {
            guard contains(element) else { continue }
            result |= 1 << index
        }
        return result
    }
    
}

extension Set where Element: RawRepresentable, Element.RawValue == Int {
    
    public init?(rawValue: Int) {
        self.init()
        var remaining = rawValue
        for bitIndex in 0..<Int.bitWidth {
            guard let thisCase = Element(rawValue: bitIndex) else { continue }
            let thisMask = 1 << bitIndex
            guard remaining & thisMask == thisMask else { continue }
            insert(thisCase)
            remaining -= thisMask
            if remaining == 0 { break }
        }
        if remaining != 0 { return nil }
    }
    
    public var rawValue: Int {
        var result = 0
        for element in self {
            result |= 1 << element.rawValue
        }
        return result
    }
    
}

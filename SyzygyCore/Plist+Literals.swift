//
//  Plist+Literals.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension Plist: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self.init(value) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(value) }
    public init(unicodeScalarLiteral value: String) { self.init(value) }
}

extension Plist: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) { self.init(value) }
    public init(floatLiteral value: Double) { self.init(value) }
}

extension Plist: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Plist)...) { self.init(Dictionary(uniqueKeysWithValues: elements)) }
}

extension Plist: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Plist...) { self.init(elements) }
}

extension Plist: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) { self.init(value) }
}

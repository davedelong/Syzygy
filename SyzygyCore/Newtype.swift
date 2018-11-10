//
//  Newtype.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol Newtype: RawRepresentable {
    init(rawValue: RawValue)
}

extension Newtype where Self: Equatable, RawValue: Equatable {
    public static func ==(left: Self, right: Self) -> Bool {
        return left.rawValue == right.rawValue
    }
}

extension Newtype where Self: Comparable, RawValue: Comparable {
    public static func <(left: Self, right: Self) -> Bool {
        return left.rawValue < right.rawValue
    }
}

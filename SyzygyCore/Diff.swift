//
//  Diff.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol DeeplyEquatable: Hashable {
    func deeplyEqual(_ other: Self) -> Bool
}

public enum Diff<T> {
    
    case insert(T, Int) // Int is the final index
    case delete(T, Int) // Int is the original index
    case replace(T, Int) // Int is the final index
    case move(T, Int, Int) // First Int is the original index, second Int is the final index
    case reload(T, Int) // Int is the final index
    
}

public extension Collection where Iterator.Element: DeeplyEquatable {
    
    public func difference<C: Collection>(to other: C) -> Array<Diff<Element>> where C.Element == Element {
        return ProgressiveDiff.diff(before: self, after: other)
    }
    
    public func absoluteDifference<C: Collection>(to other: C) -> Array<Diff<Element>> where C.Element == Element {
        return AbsoluteDiff.diff(before: self, after: other)
    }
    
}

internal protocol DiffingStrategy {
    static func diff<C, D>(before: C, after: D) -> Array<Diff<C.Element>> where C : Collection, D : Collection, C.Element : DeeplyEquatable, C.Element == D.Element
}

extension NSObject: DeeplyEquatable {
    public func deeplyEqual(_ other: NSObject) -> Bool {
        return self === other
    }
}

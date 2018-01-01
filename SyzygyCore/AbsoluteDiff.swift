//
//  AbsoluteDiff.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

internal struct AbsoluteDiff: DiffingStrategy {
    
    static func diff<C, D>(before: C, after: D) -> Array<Diff<C.Element>> where C : Collection, D : Collection, C.Element : DeeplyEquatable, C.Element == D.Element {
        typealias V = C.Iterator.Element
        
        var edits = Array<Diff<V>>()
        
        let myObjects = Set(before)
        let otherObjects = Set(after)
        
        let final = Array(after)
        var soFar = Array(before)
        
        // first, find everything that has been deleted
        for item in before.enumerated().reversed() {
            if otherObjects.contains(item.element) == false {
                edits.append(.delete(item.element, item.offset))
                soFar.remove(at: item.offset)
            }
        }
        
        // next, find everything that's been added
        for item in after.enumerated() {
            if myObjects.contains(item.element) == false {
                edits.append(.insert(item.element, item.offset))
                soFar.insert(item.element, at: item.offset)
            }
        }
        
        // at this point, `soFar` has everything it needs
        // it just might be in the wrong order
        let moves = ProgressiveDiff.diff(before: soFar, after: final)
        for move in moves {
            switch move {
            case .move(_): fallthrough
            case .reload(_): edits.append(move)
            default:
                fatalError("Tried to transform:\n\(soFar) \ninto:\n\(final) but didn't get exclusively moves or reloads. Instead got:\n\(moves)")
            }
        }
        
        return edits
    }
    
}

//
//  ProgressiveDiff.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

private protocol EditStepType {
    var isSignificantEdit: Bool { get }
}

extension Diff: EditStepType {
    var isSignificantEdit: Bool {
        if case .reload(_) = self { return false }
        return true
    }
}

private extension Collection where Element: EditStepType {
    
    var editStepCount: Int {
        return reduce(0) { $0 + ($1.isSignificantEdit ? 1 : 0) }
    }
    
}
private struct XY: Hashable {
    static func ==(lhs: XY, rhs: XY) -> Bool { return lhs.a == rhs.a && lhs.b == rhs.b }
    let a: Int
    let b: Int
    let hashValue: Int
    init(_ a: Int, _ b: Int) {
        self.a = a
        self.b = b
        hashValue = a.hashValue ^ b.hashValue
    }
}

internal struct ProgressiveDiff: DiffingStrategy {
    static func diff<C, D>(before: C, after: D) -> Array<Diff<C.Element>> where C : Collection, D : Collection, C.Element : DeeplyEquatable, C.Element == D.Element {
        typealias V = C.Element
        
        var matrix = Dictionary<XY, Array<Diff<V>>>()
        matrix[XY(-1, -1)] = []
        
        let from = Array(before)
        let to = Array(after)
        
        var previousEdits = Array<Diff<V>>()
        for (index, item) in after.enumerated() {
            let theseEdits = previousEdits + [.insert(item, index)]
            matrix[XY(-1, index)] = theseEdits
            previousEdits = theseEdits
        }
        
        previousEdits = []
        for (index, item) in before.enumerated() {
            let theseEdits = previousEdits + [.delete(item, index)]
            matrix[XY(index, -1)] = theseEdits
            previousEdits = theseEdits
        }
        
        for (tIndex, tItem) in to.enumerated() {
            for (fIndex, fItem) in from.enumerated() {
                let key = XY(fIndex, tIndex)
                let deletions = matrix[XY(fIndex - 1, tIndex)]!
                let insertions = matrix[XY(fIndex, tIndex - 1)]!
                let replacings = matrix[XY(fIndex - 1, tIndex - 1)]!
                
                
                let edits: Array<Diff<V>>
                if fItem == tItem && fItem.deeplyEqual(tItem) == true {
                    // no change
                    edits = replacings
                } else if fItem == tItem && fItem.deeplyEqual(tItem) == false {
                    // no change, but reload
                    edits = replacings + [.reload(tItem, tIndex)]
                } else if deletions.editStepCount <= insertions.editStepCount && deletions.editStepCount <= replacings.editStepCount {
                    // delete!
                    edits = deletions + [.delete(fItem, fIndex)]
                } else if insertions.editStepCount <= deletions.editStepCount && insertions.editStepCount <= replacings.editStepCount {
                    // insert!
                    edits = insertions + [.insert(tItem, tIndex)]
                } else {
                    // replace!
                    edits = replacings + [.replace(tItem, tIndex)]
                }
                matrix[key] = edits
            }
        }
        
        let edits = matrix[XY(from.count-1, to.count-1)]!
        
        // now that we have these edits, we can see if we delete+insert the same item
        var finalEdits = Array<Diff<V>>()
        var handledIndexes = Set<Int>()
        
        for (index, edit) in edits.enumerated() {
            if handledIndexes.contains(index) { continue }
            
            var newEdit = edit
            for (otherIndex, otherEdit) in edits.enumerated() {
                if index == otherIndex { continue }
                switch (edit, otherEdit) {
                case let (.insert(item, index), .delete(otherItem, otherItemIndex)) where item == otherItem:
                    newEdit = .move(item, otherItemIndex, index)
                    handledIndexes.insert(otherIndex)
                    break
                case let (.delete(item, index), .insert(otherItem, otherItemIndex)) where item == otherItem:
                    newEdit = .move(item, index, otherItemIndex)
                    handledIndexes.insert(otherIndex)
                    break
                default:
                    break
                }
            }
            finalEdits.append(newEdit)
        }
        return finalEdits
    }
}

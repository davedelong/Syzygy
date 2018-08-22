//
//  SegmentedDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Abort.Reason {
    public static func child(_ child: AnyDataSource, isNotCurrent current: AnyDataSource) -> Abort.Reason {
        return Abort.Reason("Child \(child) is not the expected \(current)")
    }
}

open class SegmentedDataSource: AnyDataSource {
    
    public enum ChangeSemantic {
        case horizontal
        case vertical
    }
    
    private var children = Array<AnyDataSource>()
    private var currentIndex = 0
    private var current: AnyDataSource { return children[currentIndex] }
    private var switchingChildren = false
    private let changeSemantic: ChangeSemantic
    
    public init(children: Array<AnyDataSource>, changeSemantic: ChangeSemantic = .vertical) {
        Assert.that(children.isNotEmpty, because: "Cannot create a SegmentedDataSource with no segments")
        self.children = children
        self.changeSemantic = changeSemantic
        super.init()
    }
    
    public func switchToSegment(at index: Int) {
        guard index != currentIndex else { return }
        Assert.that(index >= 0, because: "Segment indexes cannot be negative (\(index))")
        Assert.that(index < children.count, because: "Cannot switch to nonexistent segment \(index)")
        
        let old = current
        let oldIndex = currentIndex
        
        let new = children[index]
        let newIndex = index
        
        switchingChildren = true
        old.move(to: nil)
        new.move(to: self)
        currentIndex = index
        switchingChildren = false
        
        parent?.childWillBeginBatchedChanges(self)
        
        if changeSemantic == .vertical {
        
            let rowsToReload = min(old.numberOfItems(), new.numberOfItems())
            let rowsToInsert = new.numberOfItems() - old.numberOfItems()
            
            for i in 0 ..< rowsToReload {
                parent?.child(self, wantsReloadOfItemAt: i + 1, semantic: .fade)
            }
            
            if rowsToInsert < 0 {
                // delete some rows
                for i in 0 ..< abs(rowsToInsert) {
                    parent?.child(self, didRemoveItemAt: 1 + rowsToReload + i, semantic: .top)
                }
            } else {
                // insert some rows
                for i in 0 ..< rowsToInsert {
                    parent?.child(self, didInsertItemAt: 1 + rowsToReload + i, semantic: .top)
                }
            }
            
        } else {
            let removeDirection: DataSourceChangeSemantic
            let insertDirection: DataSourceChangeSemantic
            
            if oldIndex < newIndex {
                // moving left-to-right
                removeDirection = .right
                insertDirection = .left
            } else {
                // moving right-to-left
                removeDirection = .left
                insertDirection = .right
            }
            
            for i in 0 ..< old.numberOfItems() {
                parent?.child(self, didRemoveItemAt: i + 1, semantic: removeDirection)
            }
            for i in 0 ..< new.numberOfItems() {
                parent?.child(self, didInsertItemAt: i + 1, semantic: insertDirection)
            }
        }
        parent?.childDidEndBatchedChanges(self)
    }
    
    override func numberOfItems() -> Int {
        return 1 + current.numberOfItems()
    }
    
    override func didSelectItem(at index: Int) {
        current.didSelectItem(at: index - 1)
    }
    
    override func registerWithParent() {
        current.registerWithParent()
    }
    
    override func cellForItem(at index: Int) -> PlatformView? {
        if index == 0 {
            // TODO: return the segmented cell
            return nil
        } else {
            return current.cellForItem(at: index - 1)
        }
    }
    
}

extension SegmentedDataSource: DataSourceParent {
    
    public func register(nib: PlatformNib, for cellReuseIdentifier: String) {
        parent?.register(nib: nib, for: cellReuseIdentifier)
    }
    
    public func register(class aClass: AnyClass, for cellReuseIdentifier: String) {
        parent?.register(class: aClass, for: cellReuseIdentifier)
    }
    
    public func child(_ child: AnyDataSource, dequeueCellFor reuseIdentifier: String) -> PlatformView? {
        return parent?.child(self, dequeueCellFor: reuseIdentifier)
    }
    
    public func childWillBeginBatchedChanges(_ child: AnyDataSource) {
        guard switchingChildren == false else { return }
        parent?.childWillBeginBatchedChanges(self)
    }
    
    public func child(_ child: AnyDataSource, didInsertItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, isNotCurrent: current))
        parent?.child(self, didInsertItemAt: index + 1, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, isNotCurrent: current))
        parent?.child(self, didRemoveItemAt: index + 1, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, isNotCurrent: current))
        parent?.child(self, didMoveItemAt: oldIndex + 1, to: newIndex + 1)
    }
    
    public func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, isNotCurrent: current))
        parent?.child(self, wantsReloadOfItemAt: index + 1, semantic: semantic)
    }
    
    public func childDidEndBatchedChanges(_ child: AnyDataSource) {
        guard switchingChildren == false else { return }
        parent?.childDidEndBatchedChanges(self)
    }
    
    
}

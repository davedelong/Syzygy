//
//  CompositeDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Abort.Reason {
    public static func child(_ child: AnyDataSource, mustHaveParent parent: AnyDataSource) -> Abort.Reason {
        let p = String(describing: child.parent)
        let r = "DataSource \(child) has parent \(p), but should have parent \(parent)"
        return Abort.Reason(r)
    }
}

open class CompositeDataSource: AnyDataSource {
    
    private var children = Array<AnyDataSource>()
    private var itemCount = 0
    
    public init(children: Array<AnyDataSource> = []) {
        super.init()
        children.forEach { addChild($0) }
    }
    
    public func addChild(_ child: AnyDataSource) {
        if child.parent === self { return }
        children.append(child)
        child.move(to: self)
    }
    
    public func removeChild(_ child: AnyDataSource) {
        Assert.that(child.parent === self, because: .child(child, mustHaveParent: self))
        let index = children.index(of: child) !! "Child \(child) has parent \(self), but is not in children array"
        child.move(to: nil)
        children.remove(at: index)
    }
    
    private func offset(for child: AnyDataSource) -> Int? {
        var offset = 0
        for thisChild in children {
            if child === thisChild { return offset }
            offset += thisChild.numberOfItems()
        }
        return nil
    }
    
    private func child(for index: Int) -> (AnyDataSource, Int)? {
        var offset = index
        for thisChild in children {
            if offset < thisChild.numberOfItems() {
                return (thisChild, offset)
            }
            offset -= thisChild.numberOfItems()
        }
        return nil
    }
    
    // Abstract overrides
    
    override func registerWithParent() {
        children.forEach { $0.registerWithParent() }
    }
    
    override func cellForItem(at index: Int) -> PlatformView? {
        let (child, childIndex) = self.child(for: index) !! "Invalid cell offset: \(index)"
        return child.cellForItem(at: childIndex)
    }
    
    override func didSelectItem(at index: Int) {
        let (child, childIndex) = self.child(for: index) !! "Invalid cell offset: \(index)"
        child.didSelectItem(at: childIndex)
    }
    
}

extension CompositeDataSource: DataSourceParent {
    
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
        parent?.childWillBeginBatchedChanges(self)
    }
    
    public func child(_ child: AnyDataSource, didInsertItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard let offset = offset(for: child) else { return }
        itemCount += 1
        parent?.child(self, didInsertItemAt: offset + index, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard let offset = offset(for: child) else { return }
        itemCount -= 1
        parent?.child(self, didRemoveItemAt: offset + index, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int) {
        guard let offset = offset(for: child) else { return }
        parent?.child(self, didMoveItemAt: offset + oldIndex, to: offset + newIndex)
    }
    
    public func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard let offset = offset(for: child) else { return }
        parent?.child(self, wantsReloadOfItemAt: offset + index, semantic: semantic)
    }
    
    public func childDidEndBatchedChanges(_ child: AnyDataSource) {
        parent?.childDidEndBatchedChanges(self)
    }
}

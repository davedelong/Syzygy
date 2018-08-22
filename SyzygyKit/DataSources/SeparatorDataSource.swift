//
//  SeparatorDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class SeparatorDataSource: AnyDataSource {
    
    private let child: AnyDataSource
    
    public init(child: AnyDataSource) {
        self.child = child
        super.init()
        child.move(to: self)
    }
    
    private func childIndex(for index: Int) -> Int? {
        guard index % 2 == 1 else { return nil }
        let i = index - 1
        return i / 2
    }
    
    private func index(for childIndex: Int) -> Int {
        return (childIndex * 2) + 1
    }
    
    // Abstract overrides
    
    override func numberOfItems() -> Int {
        let n = child.numberOfItems()
        if n == 0 { return 0 }
        return (2 * n) + 1
    }
    
    override func registerWithParent() {
        // TODO: register the separator view
        child.registerWithParent()
    }
    
    override func cellForItem(at index: Int) -> PlatformView? {
        if let childIndex = self.childIndex(for: index) {
            return child.cellForItem(at: childIndex)
        } else {
            // it's a separator cell
            return nil
        }
    }
    
    override func didSelectItem(at index: Int) {
        let childIndex = self.childIndex(for: index) !! "Separator lines are not selectable"
        child.didSelectItem(at: childIndex)
    }
    
}

extension SeparatorDataSource: DataSourceParent {
    
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
        
        
        if child.numberOfItems() == 1 {
            // this is the first item in the child
            // we also need to insert the top separator
            parent?.child(self, didInsertItemAt: 0, semantic: semantic)
        }
        
        let translatedIndex = self.index(for: index)
        let separatorAfter = translatedIndex + 1
        parent?.child(self, didInsertItemAt: translatedIndex, semantic: semantic)
        parent?.child(self, didInsertItemAt: separatorAfter, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic) {
        if child.numberOfItems() == 0 {
            // this was the last item in the child
            // we also need to delete the top separator
            parent?.child(self, didRemoveItemAt: 0, semantic: semantic)
        }
        
        let translatedIndex = self.index(for: index)
        let separatorAfter = translatedIndex + 1
        parent?.child(self, didRemoveItemAt: translatedIndex, semantic: semantic)
        parent?.child(self, didRemoveItemAt: separatorAfter, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int) {
        let translatedOld = self.index(for: oldIndex)
        let translatedNew = self.index(for: newIndex)
        
        parent?.child(self, didMoveItemAt: translatedOld, to: translatedNew)
    }
    
    public func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic) {
        let translatedIndex = self.index(for: index)
        parent?.child(self, wantsReloadOfItemAt: translatedIndex, semantic: semantic)
    }
    
    public func childDidEndBatchedChanges(_ child: AnyDataSource) {
        parent?.childDidEndBatchedChanges(self)
    }
}

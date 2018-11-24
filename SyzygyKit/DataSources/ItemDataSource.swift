//
//  ItemDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class ItemDataSource: AnyDataSource {
    
    private var items = Array<DataSourceItem>()
    
    override func registerWithParent() {
        guard let p = parent else { return }
        items.forEach { $0.register(with: p) }
    }
    
    override func numberOfItems() -> Int {
        return items.count
    }
    
    override func cellForItem(at index: Int) -> DataSourceRowView? {
        guard let p = parent else { return nil }
        let item = items[index]
        return item.cell(from: p)
    }
    
    override func didSelectItem(at index: Int) {
        let item = items[index]
        item.handleSelection()
    }
    
    override func contextualActions(at index: Int) -> Array<Action> {
        let item = items[index]
        return item.contextualActions()
    }
    
    public func addItem(_ item: DataSourceItem) {
        if items.first(where: { $0 === item }) != nil {
            return
        }
        
        let index = items.count
        items.append(item)
        
        if let p = parent {
            item.register(with: p)
            parent?.childWillBeginBatchedChanges(self)
            parent?.child(self, didInsertItemAt: index, semantic: .enterTopToBottom)
            parent?.childDidEndBatchedChanges(self)
        }
    }
    
    public func removeAllItems() {
        let count = items.count
        guard count > 0 else { return }
        
        items = []
        
        parent?.childWillBeginBatchedChanges(self)
        for i in (0 ..< count).reversed() {
            parent?.child(self, didRemoveItemAt: i, semantic: .exitBottomToTop)
        }
        parent?.childDidEndBatchedChanges(self)
    }
    
    public func replaceAllItems(with item: DataSourceItem) {
        let count = items.count
        
        if count == 0 {
            addItem(item)
        } else {
            items = [item]
            if let p = parent {
                item.register(with: p)
            }
            parent?.childWillBeginBatchedChanges(self)
            parent?.child(self, wantsReloadOfItemAt: 0, semantic: .inPlace)
            for i in 1 ..< count {
                parent?.child(self, didRemoveItemAt: i, semantic: .exitBottomToTop)
            }
            parent?.childDidEndBatchedChanges(self)
        }
    }
    
    public func removeItem(_ item: DataSourceItem) {
        guard let index = items.firstIndex(where: { $0 === item }) else { return }
        
        items.remove(at: index)
        
        parent?.childWillBeginBatchedChanges(self)
        parent?.child(self, didRemoveItemAt: index, semantic: .exitBottomToTop)
        parent?.childDidEndBatchedChanges(self)
    }
    
    public func reloadItem(_ item: DataSourceItem) {
        guard let index = items.firstIndex(where: { $0 === item }) else { return }
        
        parent?.childWillBeginBatchedChanges(self)
        parent?.child(self, wantsReloadOfItemAt: index, semantic: .inPlace)
        parent?.childDidEndBatchedChanges(self)
    }
    
    public func replaceItem(_ item: DataSourceItem, with newItem: DataSourceItem) {
        if let index = items.firstIndex(where: { $0 === item }) {
            items[index] = newItem
            if let p = parent {
                newItem.register(with: p)
            }
            parent?.childWillBeginBatchedChanges(self)
            parent?.child(self, wantsReloadOfItemAt: index, semantic: .inPlace)
            parent?.childDidEndBatchedChanges(self)
        } else {
            addItem(newItem)
        }
    }
    
    public func performChanges(_ changes: () -> Void) {
        parent?.childWillBeginBatchedChanges(self)
        changes()
        parent?.childDidEndBatchedChanges(self)
    }
    
}

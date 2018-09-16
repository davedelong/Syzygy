//
//  DataSourceAdapter~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

public class DataSourceAdapter: NSObject {
    
    private let dataSource: AnyDataSource
    private weak var tableView: UITableView?
    private var batchCount = 0
    
    fileprivate let actionHandler = ContextualActionHandler()
    
    public init(dataSource: AnyDataSource, tableView: UITableView) {
        self.dataSource = dataSource
        self.tableView = tableView
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        dataSource.move(to: self)
    }
    
}

extension DataSourceAdapter: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.cellForItem(at: indexPath.row) !! "DataSource \(dataSource) did not provide a cell for \(indexPath)"
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        if cell.selectionStyle == .none { return nil }
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let actions = dataSource.contextualActions(at: indexPath.row)
        actionHandler.update(with: actions)
        return actionHandler.hasActions
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return actionHandler.canPerform(action)
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        actionHandler.perform(action, sender: sender)
    }
}

extension DataSourceAdapter: DataSourceParent {
    
    public func register(nib: PlatformNib, for cellReuseIdentifier: String) {
        tableView?.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    public func register(class aClass: AnyClass, for cellReuseIdentifier: String) {
        tableView?.register(aClass, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    public func child(_ child: AnyDataSource, dequeueCellFor reuseIdentifier: String) -> DataSourceRowView? {
        return tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier)
    }
    
    public func childWillBeginBatchedChanges(_ child: AnyDataSource) {
        if batchCount == 0 { tableView?.beginUpdates() }
        batchCount += 1
    }
    
    public func child(_ child: AnyDataSource, didInsertItemAt index: Int, semantic: DataSourceChangeSemantic) {
        tableView?.insertRows(at: [IndexPath(row: index, section: 0)], with: semantic.rowAnimation)
    }
    
    public func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic) {
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: semantic.rowAnimation)
    }
    
    public func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int) {
        tableView?.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
    }
    
    public func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic) {
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: semantic.rowAnimation)
    }
    
    public func childDidEndBatchedChanges(_ child: AnyDataSource) {
        batchCount -= 1
        if batchCount == 0 { tableView?.endUpdates() }
        Assert.that(batchCount >= 0, because: "Imbalanced calls to begin/end batched changes!")
    }
    
    
}

extension DataSourceChangeSemantic {
    internal var rowAnimation: UITableView.RowAnimation {
        switch self {
            case .automatic: return .automatic
            case .instantaneous: return .none
            case .inPlace: return .fade
            case .middle: return .middle
            
            case .enterLeftToRight: return .left
            case .exitRightToLeft: return .left
        
            case .enterRightToLeft: return .right
            case .exitLeftToRight: return .right
            
            case .enterTopToBottom: return .top
            case .exitBottomToTop: return .top
            
            case .enterBottomToTop: return .bottom
            case .exitTopToBottom: return .bottom
        }
    }
}

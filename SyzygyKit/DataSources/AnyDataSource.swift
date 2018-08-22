//
//  AnyDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public enum DataSourceChangeSemantic {
    case none
    case automatic
    case fade
    case left
    case right
    case top
    case bottom
    case middle
}

public protocol DataSourceParent: AnyObject {
    func register(nib: PlatformNib, for cellReuseIdentifier: String)
    func register(class aClass: AnyClass, for cellReuseIdentifier: String)
    
    func child(_ child: AnyDataSource, dequeueCellFor reuseIdentifier: String) -> PlatformView? // TODO: PlatformTableViewCell
    
    // notify of changes
    func childWillBeginBatchedChanges(_ child: AnyDataSource)
    func child(_ child: AnyDataSource, didInsertItemAt index: Int, semantic: DataSourceChangeSemantic)
    func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic)
    func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int)
    func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic)
    func childDidEndBatchedChanges(_ child: AnyDataSource)
}

open class AnyDataSource: Equatable {
    
    public static func ==(lhs: AnyDataSource, rhs: AnyDataSource) -> Bool { return lhs === rhs }
    
    public internal(set) weak var parent: DataSourceParent?
    
    // NS_REQUIRES_SUPER
    func move(to newParent: DataSourceParent?) {
        if parent != nil {
            parent?.childWillBeginBatchedChanges(self)
            for index in 0 ..< numberOfItems() {
                parent?.child(self, didRemoveItemAt: index, semantic: .automatic)
            }
            parent?.childDidEndBatchedChanges(self)
        }
        
        parent = newParent
        
        if parent != nil {
            registerWithParent()
            parent?.childWillBeginBatchedChanges(self)
            for index in 0 ..< numberOfItems() {
                parent?.child(self, didInsertItemAt: index, semantic: .automatic)
            }
            parent?.childDidEndBatchedChanges(self)
        }
    }
    
    func registerWithParent() {
        Abort.because(.mustBeOverridden)
    }
    
    func numberOfItems() -> Int {
        Abort.because(.mustBeOverridden)
    }
    
    func cellForItem(at index: Int) -> PlatformView? { // TODO: PlatformTableViewCell
        Abort.because(.mustBeOverridden)
    }
    
    func didSelectItem(at index: Int) {
        Abort.because(.mustBeOverridden)
    }
}

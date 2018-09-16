//
//  AnyDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public enum DataSourceChangeSemantic {
    case automatic
    case instantaneous
    case inPlace
    case middle
    
    case enterLeftToRight
    case enterRightToLeft
    case enterTopToBottom
    case enterBottomToTop
    
    case exitLeftToRight
    case exitRightToLeft
    case exitTopToBottom
    case exitBottomToTop
}

#if BUILDING_FOR_DESKTOP
public typealias DataSourceRowView = NSTableRowView
#elseif BUILDING_FOR_MOBILE
public typealias DataSourceRowView = UITableViewCell
#else
#error("Building for unknown platform")
#endif

public protocol DataSourceParent: AnyObject {
    func register(nib: PlatformNib, for cellReuseIdentifier: String)
    func register(class aClass: AnyClass, for cellReuseIdentifier: String)
    
    func child(_ child: AnyDataSource, dequeueCellFor reuseIdentifier: String) -> DataSourceRowView?
    
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
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
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
    
    func cellForItem(at index: Int) -> DataSourceRowView? {
        Abort.because(.mustBeOverridden)
    }
    
    func didSelectItem(at index: Int) {
        Abort.because(.mustBeOverridden)
    }
    
    func contextualActions(at index: Int) -> Array<Action> {
        return []
    }
}

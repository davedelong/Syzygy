//
//  DataSourceItem.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol DataSourceItem: AnyObject {
    
    // required
    func cell(from parent: DataSourceParent) -> DataSourceRowView?
    
    // optional
    func register(with parent: DataSourceParent)
    func handleSelection()
    func contextualActions() -> Array<Action>
    
}

extension DataSourceItem {
    
    public func register(with parent: DataSourceParent) { }
    public func handleSelection() { }
    public func contextualActions() -> Array<Action> { return [] }
    
}

extension DataSourceItem where Self: DataSourceRowView {
    
    public func cell(from parent: DataSourceParent) -> DataSourceRowView? { return self }
    
}

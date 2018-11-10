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

open class DataSourceItemCell: UITableViewCell, DataSourceItem {
    
    public var selectionAction: Action? {
        didSet { selectable = selectionAction != nil }
    }
    
    public var actions = Array<Action>()
    
    public init() {
        super.init(style: .default, reuseIdentifier: "\(type(of: self))")
        selectable = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectable = false
    }
    
    public func handleSelection() {
        selectionAction?.handler(self)
    }
    
    public func contextualActions() -> Array<Action> {
        return actions
    }
    
    open override func responds(to aSelector: Selector!) -> Bool {
        var ok = super.responds(to: aSelector)
        
        if ok == false {
            ok = actions.contains(where: { $0.selector == aSelector })
        }
        
        return ok
    }
    
    open override func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        if let action = actions.first(where: { $0.selector == aSelector }) {
            action.handler(object)
            return nil
        }
        return super.perform(aSelector, with: object)
    }
    
}

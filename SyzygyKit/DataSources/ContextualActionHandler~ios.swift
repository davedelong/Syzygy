//
//  ContextualActionHandler~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

internal class ContextualActionHandler: NSObject {
    
    private var actions = Array<Action>()
    private var selectors = Array<Selector>()
    
    internal var hasActions: Bool { return actions.isNotEmpty }
    
    internal override init() {
        super.init()
    }
    
    internal func update(with actions: Array<Action>) {
        self.actions = actions
        
        self.selectors = (0..<actions.count).map { Selector("\($0):")}
        
        let menuItems = zip(actions, selectors).map { (a, s) in
            return UIMenuItem(title: a.name, action: s)
        }
        
        let menu = UIMenuController.shared
        menu.menuItems = menuItems
    }
    
    internal func canPerform(_ selector: Selector) -> Bool {
        return selectors.contains(selector)
    }
    
    internal func perform(_ selector: Selector, sender: Any?) {
        guard let index = selectors.index(of: selector) else { return }
        let action = actions[index]
        action.handler(sender)
    }
    
}

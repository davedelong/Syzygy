//
//  ContextualActionHandler~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

internal class ContextualActionHandler: NSObject {
    
    private var allActions = Array<Action>()
    private var actions = Array<Action>()
    
    internal override init() {
        super.init()
    }
    
    internal func update(with actions: Array<Action>) -> Bool {
        allActions = actions
        let nonStandard = actions.filter { $0.isStandardEditAction == false }
        self.actions = nonStandard
        
        let menuItems = nonStandard.map { a in
            return UIMenuItem(title: a.name, action: a.selector)
        }
        
        let menu = UIMenuController.shared
        menu.menuItems = menuItems
        
        return allActions.isNotEmpty
    }
    
    internal func canPerform(_ selector: Selector) -> Bool {
        return allActions.any { $0.selector == selector }
    }
    
    internal func perform(_ selector: Selector, sender: Any?) {
        let action = allActions.first { $0.selector == selector }
        action?.handler(sender)
    }
    
}

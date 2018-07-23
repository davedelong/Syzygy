//
//  TargetAction.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol TargetActionProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

public extension TargetActionProtocol {
    
    public var actionBlock: ((Self) -> Void)? {
        get {
            let action: ActionTarget<Self>? = associatedObject(for: &ActionTargetAssociatedObjectKey)
            return action?.actionBlock
        }
        set {
            setAssociatedObject(nil, forKey: &ActionTargetAssociatedObjectKey)
            self.target = nil
            self.action = nil
            
            guard let block = newValue else { return }
            let target = ActionTarget(block: block)
            self.target = target
            self.action = #selector(ActionTarget<Self>.actionMethod(_:))
            setAssociatedObject(target, forKey: &ActionTargetAssociatedObjectKey)
        }
    }
    
}

internal var ActionTargetAssociatedObjectKey: UInt8 = 0

internal class ActionTarget<T>: NSObject {
    internal let actionBlock: (T) -> Void
    
    init(block: @escaping (T) -> Void) {
        self.actionBlock = block
        super.init()
    }
    
    @objc func actionMethod(_ sender: Any) {
        guard let typedSender = sender as? T else { return }
        actionBlock(typedSender)
    }
    
    #if BUILDING_FOR_DESKTOP
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return menuItem.isEnabled
    }
    #endif
}

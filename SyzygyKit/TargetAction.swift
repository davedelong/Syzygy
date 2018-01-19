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
    
    public var actionBlock: ((Any) -> Void)? {
        get {
            let action: ActionTarget? = associatedObject(for: &ActionTarget.AssociatedObjectKey)
            return action?.actionBlock
        }
        set {
            setAssociatedObject(nil, forKey: &ActionTarget.AssociatedObjectKey)
            self.target = nil
            self.action = nil
            
            guard let block = newValue else { return }
            let target = ActionTarget(block: block)
            self.target = target
            self.action = #selector(ActionTarget.actionMethod(_:))
            setAssociatedObject(target, forKey: &ActionTarget.AssociatedObjectKey)
        }
    }
    
}

#if os(macOS)
    
extension NSControl: TargetActionProtocol { }
extension NSMenuItem: TargetActionProtocol { }
    
#endif

internal class ActionTarget: NSObject {
    internal static var AssociatedObjectKey: UInt8 = 0
    internal let actionBlock: (Any) -> Void
    
    init(block: @escaping (Any) -> Void) {
        self.actionBlock = block
        super.init()
    }
    
    @objc func actionMethod(_ sender: Any) {
        actionBlock(sender)
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return menuItem.isEnabled
    }
}

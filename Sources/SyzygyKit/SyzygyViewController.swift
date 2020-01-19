//
//  SyzygyViewController~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_MAC

open class SyzygyViewController: _SyzygyViewControllerBase {
    
    public typealias TransitionOptions = NSViewController.TransitionOptions
    
    // Gestures
    internal var rightClickRecognizer: PlatformClickGestureRecognizer?
    internal var doubleClickRecognizer: PlatformClickGestureRecognizer?
    
    public func updateChildren(_ newChildren: Array<PlatformViewController>) {
        super.children = newChildren
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if view.identifier == nil {
            view.identifier = NSUserInterfaceItemIdentifier(rawValue: "\(type(of: self)).SyzygyView.\(view)")
        }
        
        if overrides(#selector(rightClickAction(_:)), upTo: SyzygyViewController.self) {
            let r = NSClickGestureRecognizer(target: self, action: #selector(SyzygyViewController.rightClickAction(_:)))
            r.numberOfClicksRequired = 1
            r.buttonMask = 0x2
            r.delaysPrimaryMouseButtonEvents = false
            view.addGestureRecognizer(r)
            rightClickRecognizer = r
        }
        
        if overrides(#selector(doubleClickAction(_:)), upTo: SyzygyViewController.self) {
            let d = NSClickGestureRecognizer(target: self, action: #selector(SyzygyViewController.doubleClickAction(_:)))
            d.numberOfClicksRequired = 2
            d.buttonMask = 0x1
            d.delaysPrimaryMouseButtonEvents = false
            view.addGestureRecognizer(d)
            doubleClickRecognizer = d
        }
    }
    
    open override func insertChild(_ childViewController: PlatformViewController, at index: Int) {
        super.insertChild(childViewController, at: index)
        
        if let child = childViewController as? SyzygyViewController {
            if childViewController.parent == self {
                child.parentWantsSelection.takeValue(from: wantsSelection)
            }
        }
    }
    
    open override func removeChild(at index: Int) {
        let child = children[index]
        super.removeChild(at: index)
        
        if let child = child as? SyzygyViewController {
            child.parentWantsSelection.takeValue(from: .false)
        }
    }
    
    @objc open func rightClickAction(_ sender: Any) { }
    @objc open func doubleClickAction(_ sender: Any) { }
    
}

#elseif BUILDING_FOR_MOBILE

open class SyzygyViewController: _SyzygyViewControllerBase {
    
    open override func addChild(_ childController: PlatformViewController) {
        super.addChild(childController)
        if let child = childController as? SyzygyViewController {
            if childController.parent == self {
                child.parentWantsSelection.takeValue(from: wantsSelection)
            }
        }
    }
    
    open override func removeFromParent() {
        super.removeFromParent()
        parentWantsSelection.takeValue(from: .false)
    }
    
}

#endif

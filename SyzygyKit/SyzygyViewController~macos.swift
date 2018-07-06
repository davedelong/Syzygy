//
//  SyzygyViewController~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension SyzygyViewController {
    
    public typealias TransitionOptions = NSViewController.TransitionOptions
    
    internal func _setChildren(_ newChildren: Array<PlatformViewController>) {
        super.children = newChildren
    }
    
    internal func _platformViewDidLoad() {
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
    
}

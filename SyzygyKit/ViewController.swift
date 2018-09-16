//
//  ViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/15/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation


/**
 This protocol exists simply to make sure that I maintain the same API between UIViewController
 and NSViewController.
 */
internal protocol _PlatformViewController {
    
    var viewIfLoaded: PlatformView? { get }
    
    var loadedView: PlatformView { get }
    
    func embedChild(_ viewController: PlatformViewController, in aView: PlatformView?)
    
    func replaceChild(_ child: PlatformViewController?,
                      with newChild: PlatformViewController,
                      in container: PlatformView?,
                      duration: TimeInterval,
                      options: PlatformViewController.TransitionOptions)
    
}

public extension PlatformViewController {
    
    public func resolving(container: PlatformView?) -> PlatformView {
        let v = container ?? loadedView
        guard v.isEmbeddedIn(loadedView) else {
            Abort.because("Proposed container \(v) is not in \(self)'s view hierarchy")
        }
        return v
    }
    
    public func embedChild(_ viewController: PlatformViewController) {
        self.embedChild(viewController, in: nil)
    }
    
    public func setChildren(_ newChildren: Array<PlatformViewController>) {
        let old = Set(children)
        let new = Set(newChildren)
        
        let removed = old.subtracting(new)
        let inserted = new.subtracting(old)
        
        for child in removed {
            child.willMove(toParent: nil)
            child.removeFromParent()
        }
        
        for child in inserted {
            addChild(child)
            child.didMove(toParent: self)
        }
        
    }
    
}

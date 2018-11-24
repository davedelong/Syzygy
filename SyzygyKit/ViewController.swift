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
    
    func embedChild(_ viewController: PlatformViewController, in aView: PlatformView?, margins: PlatformEdgeInsets)
    
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
        self.embedChild(viewController, in: nil, margins: .zero)
    }
    
    public func embedChild(_ viewController: PlatformViewController, in aView: PlatformView?) {
        self.embedChild(viewController, in: aView, margins: .zero)
    }
    
    public func embedChild(_ viewController: PlatformViewController, margins: PlatformEdgeInsets) {
        self.embedChild(viewController, in: nil, margins: margins)
    }
    
    public func setChildren(_ newChildren: Array<PlatformViewController>) {
        let old = Set(children)
        let new = Set(newChildren)
        
        let removed = old.subtracting(new)
        let inserted = new.subtracting(old)
        
        for child in removed {
            #if BUILDING_FOR_MOBILE
            child.willMove(toParent: nil)
            #endif
            child.removeFromParent()
        }
        
        for child in inserted {
            addChild(child)
            #if BUILDING_FOR_MOBILE
            child.didMove(toParent: self)
            #endif
        }
        
    }
    
    func replaceChild(_ child: PlatformViewController?,
                      with newChild: PlatformViewController,
                      in container: PlatformView? = nil) {
        
        self.replaceChild(child, with: newChild, in: container, duration: 0.3, options: [.crossfade])
    }
    
}

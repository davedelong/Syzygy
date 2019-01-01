//
//  NSViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

extension NSViewController: _PlatformViewController {
    
    var loadedView: PlatformView { return view }
    
    func embedChild(_ viewController: PlatformViewController, in aView: PlatformView?, margins: PlatformEdgeInsets) {
        let targetView = resolving(container: aView)
        
        if viewController.loadedView.superview != targetView {
            viewController.loadedView.removeFromSuperview()
        }
        
        if viewController.parent != self {
            viewController.removeFromParent()
            addChild(viewController)
        }
        
        if viewController.loadedView.superview != targetView {
            targetView.embedSubview(viewController.loadedView, margins: margins)
        }
    }
    
    
    internal var _actualView: NSView { return view }
    
    public var viewIfLoaded: NSView? {
        guard isViewLoaded else { return nil }
        return view
    }
    
    func replaceChild(_ child: PlatformViewController?,
                      with newChild: PlatformViewController,
                      in container: PlatformView?,
                      duration: TimeInterval,
                      options: PlatformViewController.TransitionOptions) {
        
        let old = child ?? SyzygyViewController(ui: .empty)
        let new = newChild
        
        let needsSourceRemoval = child == nil
        
        // transitioning expects that all view controllers are children of self
        let oldView = old.view
        let newView = new.view
        
        let targetContainer = oldView.superview ?? container ?? view
        
        if old.parent != self {
            oldView.removeFromSuperview()
            old.removeFromParent()
            addChild(old)
        }
        
        if oldView.superview != targetContainer {
            oldView.removeFromSuperview()
            oldView.alphaValue = 1.0
            oldView.autoresizingMask = [.height, .width]
            oldView.translatesAutoresizingMaskIntoConstraints = true
            oldView.frame = targetContainer.bounds
            targetContainer.addSubview(oldView)
        }
        
        if new.parent != self {
            newView.removeFromSuperview()
            new.removeFromParent()
            addChild(new)
        }
        
        if newView.superview != targetContainer {
            newView.removeFromSuperview()
            newView.alphaValue = 1.0
            newView.autoresizingMask = [.height, .width]
            newView.translatesAutoresizingMaskIntoConstraints = true
            newView.frame = targetContainer.bounds
            targetContainer.addSubview(newView, positioned: .below, relativeTo: oldView)
        }
        
        self.transition(from: old, to: new, options: options) {
            if needsSourceRemoval {
                oldView.removeFromSuperview()
                old.removeFromParent()
            }
        }
        
    }
    
}

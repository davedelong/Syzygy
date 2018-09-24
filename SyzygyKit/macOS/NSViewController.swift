//
//  NSViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

extension NSViewController: _PlatformViewController {
    
    var loadedView: PlatformView { return view }
    
    func embedChild(_ viewController: PlatformViewController, in aView: PlatformView?) {
        let targetView = resolving(container: aView)
        
        if viewController.loadedView.superview != targetView {
            viewController.loadedView.removeFromSuperview()
        }
        
        if viewController.parent != self {
            viewController.removeFromParent()
            addChild(viewController)
        }
        
        if viewController.loadedView.superview != targetView {
            targetView.embedSubview(viewController.loadedView)
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
        
        let source = child ?? SyzygyViewController(ui: .empty)
        let dest = newChild
        
        let needsSourceRemoval = child == nil
        
        // transitioning expects that all view controllers are children of self
        let sourceView = source.view
        let destView = dest.view
        
        let targetContainer = sourceView.superview ?? container ?? view
        
        if source.parent != self {
            sourceView.removeFromSuperview()
            source.removeFromParent()
            addChild(source)
        }
        
        if sourceView.superview != targetContainer {
            sourceView.removeFromSuperview()
            sourceView.alphaValue = 1.0
            sourceView.autoresizingMask = [.height, .width]
            sourceView.translatesAutoresizingMaskIntoConstraints = true
            sourceView.frame = targetContainer.bounds
            targetContainer.addSubview(sourceView, positioned: .above, relativeTo: destView)
        }
        
        if dest.parent != self {
            destView.removeFromSuperview()
            dest.removeFromParent()
            addChild(dest)
        }
        
        if destView.superview != targetContainer {
            destView.removeFromSuperview()
            destView.alphaValue = 1.0
            destView.autoresizingMask = [.height, .width]
            destView.translatesAutoresizingMaskIntoConstraints = true
            destView.frame = targetContainer.bounds
            targetContainer.addSubview(destView, positioned: .below, relativeTo: sourceView)
        }
        
        self.transition(from: source, to: dest, options: options) {
            if needsSourceRemoval {
                sourceView.removeFromSuperview()
                source.removeFromParent()
            }
        }
        
    }
    
}

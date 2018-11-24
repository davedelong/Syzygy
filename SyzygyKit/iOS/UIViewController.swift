//
//  UIViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension UIViewController: _PlatformViewController {
    
    public typealias TransitionOptions = UIView.AnimationOptions
    
    public var loadedView: UIView { return view! }
    
    public func embedChild(_ viewController: PlatformViewController, in aView: PlatformView?, margins: PlatformEdgeInsets) {
        let targetView = resolving(container: aView)
        
        if viewController.loadedView.superview != targetView {
            viewController.loadedView.removeFromSuperview()
        }
        
        if viewController.parent != self {
            viewController.beginAppearanceTransition(false, animated: false)
            viewController.willMove(toParent: nil)
            viewController.removeFromParent()
            viewController.endAppearanceTransition()
            
            viewController.beginAppearanceTransition(true, animated: false)
            addChild(viewController)
            viewController.didMove(toParent: self)
            viewController.endAppearanceTransition()
        }
        
        if viewController.loadedView.superview != targetView {
            targetView.embedSubview(viewController.loadedView, margins: margins)
        }
    }
    
    public func replaceChild(_ child: PlatformViewController?,
                             with newChild: PlatformViewController,
                             in container: PlatformView? = nil,
                             duration: TimeInterval = 0.3,
                             options: PlatformViewController.TransitionOptions = [.transitionCrossDissolve]) {
        guard child != newChild else { return }
        
        let targetView = resolving(container: container)
        
        if let old = child {
            Assert.that(newChild.parent == nil, because: "Incoming view controller \(newChild) must not have a parent")
            
            Assert.that(old.loadedView.superview == targetView, because: "Incoming view controller \(newChild) must target the same container view as \(old)")
            
            old.beginAppearanceTransition(false, animated: true)
            newChild.beginAppearanceTransition(true, animated: true)
            
            old.willMove(toParent: nil)
            addChild(newChild)
            
            
            targetView.embedSubview(newChild.loadedView)
            targetView.bringSubviewToFront(old.loadedView)
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: options,
                           animations: { },
                           completion: { _ in
                            old.view.removeFromSuperview()
                            old.removeFromParent()
                            old.endAppearanceTransition()
                            
                            newChild.didMove(toParent: self)
                            newChild.endAppearanceTransition()
            })
        } else {
            newChild.loadedView.alpha = 0
            
            newChild.beginAppearanceTransition(true, animated: true)
            
            addChild(newChild)
            targetView.embedSubview(newChild.loadedView)
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                newChild.loadedView.alpha = 1
                newChild.didMove(toParent: self)
                newChild.endAppearanceTransition()
            }, completion: nil)
        }
        
    }
    
}

public extension UIView.AnimationOptions {
    public static let crossfade = UIView.AnimationOptions.transitionCrossDissolve
}

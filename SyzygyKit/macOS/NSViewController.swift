//
//  NSViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)

public extension NSViewController {
    
    public var viewIfLoaded: NSView? {
        guard isViewLoaded else { return nil }
        return view
    }
    
    public func transition(from: NSViewController?, to: NSViewController?, in container: NSView? = nil, options: NSViewController.TransitionOptions = [], completion: ((Bool) -> Void)? = nil) {
        // don't need to do anything if both are nil
        guard from != nil || to != nil else { return }
        
        let source = from ?? SyzygyViewController(ui: .empty)
        let dest = to ?? SyzygyViewController(ui: .empty)
        
        let needsSourceRemoval = from == nil
        let needsDestRemoval = to == nil
        
        // transitioning expects that all view controllers are children of self
        let sourceView = source.view
        let destView = dest.view
        
        let targetContainer = sourceView.superview ?? container ?? view
        
        if source.parent != self {
            sourceView.removeFromSuperview()
            source.removeFromParentViewController()
            addChildViewController(source)
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
            dest.removeFromParentViewController()
            addChildViewController(dest)
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
                source.removeFromParentViewController()
            }
            
            if needsDestRemoval {
                destView.removeFromSuperview()
                dest.removeFromParentViewController()
            }
            
            completion?(true)
        }
        
    }
    
}

#endif

//
//  UIViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    public func embedViewController(_ child: UIViewController, in aView: UIView? = nil) {
        let container: UIView
        if let v = aView, v.isEmbeddedIn(self.view) {
            container = v
        } else {
            container = self.view
        }
        
        if child.parent != self {
            if child.parent != nil {
                child.viewIfLoaded?.removeFromSuperview()
                child.willMove(toParent: nil)
                child.removeFromParent()
            }
            
            addChild(child)
            child.didMove(toParent: self)
        }
        
        let childView = child.view !! "Unable to load child view"
        container.embedSubview(childView)
    }
    
    public func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let duration = 0.3
        
        let current = children.last
        guard current != child else {
            completion?(true)
            return
        }
        
        addChild(child)
        
        let newView = child.view!
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds
        
        if let existing = current {
            
            existing.willMove(toParent: nil)
            
            transition(from: existing, to: child, duration: duration, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                existing.removeFromParent()
                child.didMove(toParent: self)
                completion?(done)
            })
            
        } else {
            view.addSubview(newView)
            
            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                child.didMove(toParent: self)
                completion?(done)
            })
        }
    }
    
}

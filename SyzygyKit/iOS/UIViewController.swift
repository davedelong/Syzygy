//
//  UIViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    public func embed(_ child: UIViewController, in aView: UIView?) {
        let container: UIView
        if let v = aView, v.isEmbeddedIn(self.view) {
            container = v
        } else {
            container = self.view
        }
        
        addChildViewController(child)
        child.didMove(toParentViewController: self)
        
        let childView = child.view !! "Unable to load child view"
        childView.frame = container.bounds
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childView.translatesAutoresizingMaskIntoConstraints = true
        
        container.addSubview(childView)
    }
    
    public func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let duration = 0.3
        
        let current = childViewControllers.last
        addChildViewController(child)
        
        let newView = child.view!
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds
        
        if let existing = current {
            existing.willMove(toParentViewController: nil)
            
            transition(from: existing, to: child, duration: duration, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                existing.removeFromParentViewController()
                child.didMove(toParentViewController: self)
                completion?(done)
            })
            
        } else {
            view.addSubview(newView)
            
            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                child.didMove(toParentViewController: self)
                completion?(done)
            })
        }
    }
    
}

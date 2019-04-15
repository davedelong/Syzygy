//
//  KeyboardLayoutGuide.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 4/9/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import UIKit

public extension UIView {
    
    var keyboardLayoutGuide: UILayoutGuide {
        let guide = KeyboardObserver.observer.guide
        if let w = window, guide.owningView != w {
            guide.owningView?.removeLayoutGuide(guide)
            w.addLayoutGuide(guide)
        }
        return guide
    }
    
}

private class KeyboardObserver: NSObject {
    
    static let observer = KeyboardObserver()
    
    let guide = UILayoutGuide()
    
    private weak var lastOwningView: UIView?
    
    private var x: NSLayoutConstraint?
    private var y: NSLayoutConstraint?
    private var width: NSLayoutConstraint?
    private var height: NSLayoutConstraint?
    
    override init() {
        super.init()
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(keyboardWillChangeFrame(_:)),
                       name: UIResponder.keyboardWillChangeFrameNotification,
                       object: nil)
    }
    
    private func setUpIfNecessary() {
        if lastOwningView == guide.owningView { return }
        
        x?.isActive = false; x = nil
        y?.isActive = false; y = nil
        width?.isActive = false; width = nil
        height?.isActive = false; height = nil
        lastOwningView = nil
        
        if let newOwner = guide.owningView {
            x = guide.leadingAnchor.constraint(equalTo: newOwner.leadingAnchor)
            y = guide.topAnchor.constraint(equalTo: newOwner.topAnchor)
            width = guide.widthAnchor.constraint(equalToConstant: 0)
            height = guide.heightAnchor.constraint(equalToConstant: 0)
            
            lastOwningView = newOwner
            
            x?.isActive = true
            y?.isActive = true
            width?.isActive = true
            height?.isActive = true
        }
    }
    
    @objc
    private func keyboardWillChangeFrame(_ note: Notification) {
        setUpIfNecessary()
        
        guard let frameValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let frame = frameValue.cgRectValue
        
        x?.constant = frame.origin.x
        y?.constant = frame.origin.y
        width?.constant = frame.size.width
        height?.constant = frame.size.height
        
        let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let curveInt = note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        let curve = curveInt.flatMap { UIView.AnimationCurve(rawValue: $0) }
        
        if let duration = duration, let curve = curve {
            var options = UIView.AnimationOptions()
            options.insert(.beginFromCurrentState)
            options.insert(.layoutSubviews)
            
            switch curve {
                case .easeInOut: options.insert(.curveEaseInOut)
                case .easeIn: options.insert(.curveEaseIn)
                case .easeOut: options.insert(.curveEaseOut)
                case .linear: options.insert(.curveLinear)
                @unknown default:
                    var rawCurveValue = curve.rawValue
                    rawCurveValue <<= 16
                    let option = UIView.AnimationOptions(rawValue: UInt(rawCurveValue))
                    options.insert(option)
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.guide.owningView?.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.performWithoutAnimation {
                self.guide.owningView?.layoutIfNeeded()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

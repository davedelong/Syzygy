//
//  SyzygyTouchDetectionGestureRecognizer.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 10/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

open class SyzygyTouchDetectionGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    
    public private(set) var isDetectingTouches: Bool = false
    
    override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        delegate = self
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        isDetectingTouches = true
        state = .began
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        isDetectingTouches = true
        state = .changed
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        isDetectingTouches = false
        state = .failed
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        isDetectingTouches = false
        state = .failed
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}

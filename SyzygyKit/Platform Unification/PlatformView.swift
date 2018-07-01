//
//  View.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias PlatformView = NSView
public typealias PlatformNib = NSNib
public typealias PlatformWindow = NSWindow
#else
public typealias PlatformView = UIView
public typealias PlatformNib = UINib
public typealias PlatformWindow = UIWindow

public extension UINib {
    typealias Name = String
}

public extension UIView.AutoresizingMask {
    public static let width = UIView.AutoresizingMask.flexibleWidth
    public static let height = UIView.AutoresizingMask.flexibleHeight
}

#endif

public extension PlatformView {
    
    public func isEmbeddedIn(_ other: PlatformView) -> Bool {
        var possible: PlatformView? = self
        while let p = possible {
            if p == other { return true }
            possible = p.superview
        }
        return false
    }
    
    public func firstCommonSuperview(with otherView: PlatformView) -> PlatformView? {
        let mySuperviews = sequence(first: self, next: { $0.superview })
        let theirSuperviews = Set(sequence(first: otherView, next: { $0.superview }))
        return mySuperviews.first(where: theirSuperviews.contains)
    }
    
    public func embedSubview(_ subview: PlatformView) {
        subview.removeFromSuperview()
        subview.frame = self.bounds
        #if BUILDING_FOR_DESKTOP
            subview.autoresizingMask = [.width, .height]
        #else
            subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        #endif
        subview.translatesAutoresizingMaskIntoConstraints = true
        addSubview(subview)
    }
    
}

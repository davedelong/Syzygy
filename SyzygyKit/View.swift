//
//  View.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension NSCoding where Self: PlatformView {
    
    public static func make() -> Self {
        let bundle = Bundle(for: self)
        let nib = PlatformNib(nibName: "\(self)", bundle: bundle)
        
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let matches = objects.compactMap { $0 as? Self }
        
        if let firstMatch = matches.first {
            return firstMatch
        } else {
            return Self.init()
        }
    }
    
}

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
        subview.autoresizingMask = [.width, .height]
        subview.translatesAutoresizingMaskIntoConstraints = true
        addSubview(subview)
    }
    
}

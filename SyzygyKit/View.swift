//
//  View.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension R where T == PlatformNib {
    static let nib = R<PlatformNib>()
}

public extension NSCoding where Self: PlatformView {
    
    static func make() -> Self {
        let bundle = Bundle(for: self)
        let maybeNib = PlatformNib.loadResource(name: "\(self)", in: bundle)
        let nib = maybeNib !! "Unable to load nib named \(self)"
        
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
        
    var platformLayer: CALayer? { return layer }
    
    func isEmbeddedIn(_ other: PlatformView) -> Bool {
        var possible: PlatformView? = self
        while let p = possible {
            if p == other { return true }
            possible = p.superview
        }
        return false
    }
    
    func firstCommonSuperview(with otherView: PlatformView) -> PlatformView? {
        let mySuperviews = sequence(first: self, next: { $0.superview })
        let theirSuperviews = Set(sequence(first: otherView, next: { $0.superview }))
        return mySuperviews.first(where: theirSuperviews.contains)
    }
    
    func embedSubview(_ subview: PlatformView, margins: PlatformEdgeInsets = .zero) {
        subview.removeFromSuperview()
        subview.frame = self.bounds
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.top.constraint(equalTo: top, constant: margins.top),
            bottom.constraint(equalTo: subview.bottom, constant: margins.bottom),
            
            subview.leading.constraint(equalTo: leading, constant: margins.left),
            trailing.constraint(equalTo: subview.trailing, constant: margins.right)
        ])
    }
    
    func removeAllSubviews() {
        while let n = subviews.first {
            n.removeFromSuperview()
        }
    }
    
}

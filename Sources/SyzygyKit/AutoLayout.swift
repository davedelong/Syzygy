//
//  AutoLayout.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/29/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol AnchorProviding {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension AnchorProviding {
    public var leading: NSLayoutXAxisAnchor { return leadingAnchor }
    public var trailing: NSLayoutXAxisAnchor { return trailingAnchor }
    public var left: NSLayoutXAxisAnchor { return leftAnchor }
    public var right: NSLayoutXAxisAnchor { return rightAnchor }
    
    public var top: NSLayoutYAxisAnchor { return topAnchor }
    public var bottom: NSLayoutYAxisAnchor { return bottomAnchor }
    
    public var width: NSLayoutDimension { return widthAnchor }
    public var height: NSLayoutDimension { return heightAnchor }
    
    public var centerX: NSLayoutXAxisAnchor { return centerXAnchor }
    public var centerY: NSLayoutYAxisAnchor { return centerYAnchor }
}

extension PlatformLayoutGuide: AnchorProviding { }
extension PlatformView: AnchorProviding { }

#if BUILDING_FOR_MOBILE

extension NSLayoutXAxisAnchor {
    
    public func constraint(equalToSystemSpacingAfter anchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return constraint(equalToSystemSpacingAfter: anchor, multiplier: 1.0)
    }
    
    public func constraint(greaterThanOrEqualToSystemSpacingAfter anchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualToSystemSpacingAfter: anchor, multiplier: 1.0)
    }
    
    public func constraint(lessThanOrEqualToSystemSpacingAfter anchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualToSystemSpacingAfter: anchor, multiplier: 1.0)
    }
}

extension NSLayoutYAxisAnchor {
    
    public func constraint(equalToSystemSpacingBelow anchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return constraint(equalToSystemSpacingBelow: anchor, multiplier: 1.0)
    }
    
    public func constraint(greaterThanOrEqualToSystemSpacingBelow anchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return constraint(greaterThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1.0)
    }
    
    public func constraint(lessThanOrEqualToSystemSpacingBelow anchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        return constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1.0)
    }
}

#endif

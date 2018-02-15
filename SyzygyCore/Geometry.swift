//
//  Geometry.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
public typealias CGEdgeInsets = NSEdgeInsets
    
public extension CGEdgeInsets {
    public static let zero = NSEdgeInsetsZero
}
    
#else
import UIKit
public typealias CGEdgeInsets = UIEdgeInsets
#endif

public extension CGEdgeInsets {
    
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
}

public extension CGRect {
    
    public var center: CGPoint {
        get { return CGPoint(x: midX, y: midY) }
        set {
            let size = self.size
            self = CGRect(x: newValue.x - (size.width / 2.0),
                          y: newValue.y - (size.height / 2.0),
                          width: size.width,
                          height: size.height)
        }
    }
    
    public func applying(_ insets: CGEdgeInsets) -> CGRect {
        var f = self
        f.origin.x += insets.left
        f.size.width -= (insets.left + insets.right)
        
        f.origin.y += insets.top
        f.size.height -= (insets.top + insets.bottom)
        return f
    }
    
}


public extension CGPoint {
    
    public init(polarAngle: CGFloat, length: CGFloat) {
        self.x = cos(polarAngle) * (length)
        self.y = sin(polarAngle) * -(length)
    }
    
}

public extension CGFloat {
    
    public static let tau: CGFloat = 2 * CGFloat.pi
    
}

public func dtor(_ degrees: CGFloat) -> CGFloat {
    return (degrees / 360.0 * CGFloat.tau)
}

public func rtod(_ radians: CGFloat) -> CGFloat {
    return (radians / CGFloat.tau * 360.0)
}

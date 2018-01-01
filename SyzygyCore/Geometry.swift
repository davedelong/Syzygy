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
#else
import UIKit
public typealias CGEdgeInsets = UIEdgeInsets
#endif

public extension CGRect {
    
    public func applying(insets: CGEdgeInsets) -> CGRect {
        var f = self
        f.origin.x += insets.left
        f.size.width -= (insets.left + insets.right)
        
        f.origin.y += insets.top
        f.size.height -= (insets.top + insets.bottom)
        return f
    }
    
}

public func dtor(_ degrees: CGFloat) -> CGFloat {
    return (degrees / 180.0 * CGFloat.pi)
}

public func rtod(_ radians: CGFloat) -> CGFloat {
    return (radians / CGFloat.pi * 180.0)
}

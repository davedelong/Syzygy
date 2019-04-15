//
//  Geometry.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension PlatformEdgeInsets {
    
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
}

public extension CGRect {
    
    var center: CGPoint {
        get { return CGPoint(x: midX, y: midY) }
        set {
            let size = self.size
            self = CGRect(x: newValue.x - (size.width / 2.0),
                          y: newValue.y - (size.height / 2.0),
                          width: size.width,
                          height: size.height)
        }
    }
    
    func applying(_ insets: PlatformEdgeInsets) -> CGRect {
        var f = self
        f.origin.x += insets.left
        f.size.width -= (insets.left + insets.right)
        
        f.origin.y += insets.top
        f.size.height -= (insets.top + insets.bottom)
        return f
    }
    
}


public extension CGPoint {
    
    init(polarAngle: CGFloat, length: CGFloat) {
        self.init(x: cos(polarAngle) * length,
                  y: sin(polarAngle) * -length)
    }
    
}

public extension CGFloat {
    
    static let tau: CGFloat = 2 * CGFloat.pi
    
}

public func dtor(_ degrees: CGFloat) -> CGFloat {
    return (degrees / 360.0 * CGFloat.tau)
}

public func rtod(_ radians: CGFloat) -> CGFloat {
    return (radians / CGFloat.tau * 360.0)
}

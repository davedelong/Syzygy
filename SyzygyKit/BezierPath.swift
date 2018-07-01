//
//  BezierPath.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias BezierPath = NSBezierPath
#else
public typealias BezierPath = UIBezierPath
#endif

public extension BezierPath {
    
    public convenience init (starShapeIn rect: CGRect, insets: PlatformEdgeInsets = PlatformEdgeInsets()) {
        let starFrame = rect.applying(insets)
        let center = starFrame.center
        let smallestDimension = min(starFrame.width, starFrame.height)
        let majorRadius = smallestDimension / 2
        
        // solve the triangle for the length of the minor radius
        /*
         B
         |\
         | \
         |  \ c
         |   \
         a |    \ A
         |   /
         |  /
         | / b
         |/
         C
         
         given side 'a' of length 'majorRadius',
         the length of side b (the minor radius)
         is equal to a * sin(B) / sin(A)
         
         since this is a regular pentagram, we know the angles A, B, and C (126, 18, and 36°, respectively)
         so solving for the length of the minor radius is trivial:
         */
        let minorRadius = (majorRadius * sin(dtor(18))) / sin(dtor(126))
        
        // this creates a star centered around (0,0)
        self.init()
        self.move(to: CGPoint(polarAngle: dtor(270), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(234), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(198), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(162), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(126), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(90), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(54), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(18), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-18), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-54), length: minorRadius))
        self.close()
        
        // we're not done yet, because the star is centered around 0,0
        // we want to re-center it in the middle of the inset rect
        let recenter = CGAffineTransform(translationX: center.x, y: center.y)
        self.apply(recenter)
    }
    
    #if BUILDING_FOR_DESKTOP
    var CGPath: CGPath {
        let p = CGMutablePath()
        
        let count = self.elementCount
        var didClose = false
        for i in 0 ..< count {
            
            var points = Array<NSPoint>(repeating: .zero, count: 3)
            let e = self.element(at: i, associatedPoints: &points)
            
            switch e {
            case .moveTo:
                p.move(to: points[0])
                
            case .lineTo:
                p.addLine(to: points[0])
                didClose = false
            case .curveTo:
                p.addCurve(to: points[2], control1: points[0], control2: points[1])
                didClose = false
            case .closePath:
                p.closeSubpath()
                didClose = true
            }
        }
        
        if didClose == false {
            p.closeSubpath()
        }
        
        return p
    }
    
    public func apply(_ transform: CGAffineTransform) {
        self.transform(using: AffineTransform(transform))
    }
    
    #else
    
    public func line(to point: CGPoint) { self.addLine(to: point) }
    
    public var CGPath: CGPath { return cgPath }
    #endif
}

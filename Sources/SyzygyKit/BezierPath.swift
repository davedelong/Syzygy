//
//  BezierPath.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_MAC

public typealias BezierPath = NSBezierPath

public extension BezierPath {
    
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
                @unknown default:
                    NSLog("Unknown type of path element: \(e). Skipping...")
            }
        }
        
        if didClose == false {
            p.closeSubpath()
        }
        
        return p
    }
    
    convenience init(roundedRect: NSRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
    
    func apply(_ transform: CGAffineTransform) {
        self.transform(using: AffineTransform(transform))
    }
    
    func addCurve(to: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.relativeCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    func addLine(to point: CGPoint) {
        self.line(to: point)
    }
    
}

#elseif BUILDING_FOR_MOBILE

public typealias BezierPath = UIBezierPath

public extension BezierPath {
    
    func line(to point: CGPoint) { self.addLine(to: point) }
    
    var CGPath: CGPath { return cgPath }

}

#endif

public extension BezierPath {
    
    convenience init (starShapeIn rect: CGRect, insets: PlatformEdgeInsets = PlatformEdgeInsets()) {
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
        self.move(to: CGPoint(polarAngle: dtor(90), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(54), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(18), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-18), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-54), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-90), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-126), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-162), length: minorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-198), length: majorRadius))
        self.line(to: CGPoint(polarAngle: dtor(-234), length: minorRadius))
        self.close()
        
        // we're not done yet, because the star is centered around 0,0
        // we want to re-center it in the middle of the inset rect
        let recenter = CGAffineTransform(translationX: center.x, y: center.y)
        self.apply(recenter)
    }
    
    convenience init(heartShapeIn rect: CGRect) {
        func p(x: CGFloat, y: CGFloat) -> CGPoint {
            return CGPoint(x: x / 56 * rect.size.width, y: y / 50 * rect.size.height)
        }
        
        self.init()
        self.move(to: p(x: 40, y: 0))
        self.addCurve(to: p(x: 28, y: 5.44), controlPoint1: p(x: 35.22, y: 0), controlPoint2: p(x: 30.93, y: 2.11))
        self.addCurve(to: p(x: 16, y: 0), controlPoint1: p(x: 25.07, y: 2.11), controlPoint2: p(x: 20.79, y: 0))
        self.addCurve(to: p(x: 0, y: 16), controlPoint1: p(x: 7.16, y: 0), controlPoint2: p(x: 0, y: 7.16))
        self.addCurve(to: p(x: 28, y: 50), controlPoint1: p(x: 0, y: 34), controlPoint2: p(x: 22, y: 44))
        self.addCurve(to: p(x: 56, y: 16), controlPoint1: p(x: 34, y: 44), controlPoint2: p(x: 56, y: 34))
        self.addCurve(to: p(x: 40, y: 0), controlPoint1: p(x: 56, y: 7.16), controlPoint2: p(x: 48.84, y: 0))
        self.close()
    }
    
}

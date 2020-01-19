//
//  Shape.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Shape {
    private let builder: (CGRect) -> BezierPath
    
    public init(builder: @escaping (CGRect) -> BezierPath) {
        self.builder = builder
    }
    
    public func bezierPath(in rect: CGRect) -> BezierPath { return builder(rect) }
    
    public func inset(by insets: PlatformEdgeInsets) -> Shape {
        let b = builder
        return Shape { rect in
            let insetRect = rect.applying(insets)
            let path = b(insetRect)
            path.apply(CGAffineTransform(translationX: insets.left, y: insets.top))
            return path
        }
    }
}

public extension Shape {
    
    #if BUILDING_FOR_MAC
    
    static func roundedRect(_ radius: CGFloat) -> Shape { return Shape { rect in
            return BezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
        }
    }
    
    #elseif BUILDING_FOR_MOBILE
    
    static func roundedRect(_ radius: CGFloat) -> Shape { return Shape { rect in
            return BezierPath(roundedRect: rect, cornerRadius: radius)
        }
    }
    
    #endif
    
    static let circle = Shape { rect in
        let shortestSide = min(rect.width, rect.height)
        let xOffset = rect.width - shortestSide
        let yOffset = rect.height - shortestSide
        let square = CGRect(x: xOffset, y: yOffset, width: shortestSide, height: shortestSide)
        return BezierPath(ovalIn: square)
    }
    
    static let oval = Shape { BezierPath(ovalIn: $0) }
    
    static let square = Shape { rect in
        let shortestSide = min(rect.width, rect.height)
        let xOffset = rect.width - shortestSide
        let yOffset = rect.height - shortestSide
        let square = CGRect(x: xOffset, y: yOffset, width: shortestSide, height: shortestSide)
        return BezierPath(rect: square)
    }
    
    static let rectangle = Shape { BezierPath(rect: $0) }
    
    static let horizontalPill = Shape { rect in
        let radius = rect.height / 2
        return BezierPath(roundedRect: rect, cornerRadius: radius)
    }
    
    static let verticalPill = Shape { rect in
        let radius = rect.width / 2
        return BezierPath(roundedRect: rect, cornerRadius: radius)
    }
    
    static let star = Shape { BezierPath(starShapeIn: $0) }
    static let heart = Shape { BezierPath(heartShapeIn: $0) }
}

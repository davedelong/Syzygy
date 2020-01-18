//
//  Shape~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Shape {
    
    static func roundedRect(_ radius: CGFloat) -> Shape { return Shape { rect in
            return BezierPath(roundedRect: rect, cornerRadius: radius)
        }
    }
    
}

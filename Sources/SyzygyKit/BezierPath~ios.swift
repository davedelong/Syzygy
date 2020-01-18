//
//  BezierPath~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public typealias BezierPath = UIBezierPath

public extension BezierPath {
    
    func line(to point: CGPoint) { self.addLine(to: point) }
    
    var CGPath: CGPath { return cgPath }

}

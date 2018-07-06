//
//  ShapeView~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension ShapeView {
    
    internal func _configureLayer() { }
    
    internal func _shapeNeedsUpdate() {
        setNeedsUpdateConstraints()
    }
    
}

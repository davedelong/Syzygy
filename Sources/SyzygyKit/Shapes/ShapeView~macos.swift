//
//  ShapeView~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension ShapeView {
    
    internal func _configureLayer() {
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        canDrawSubviewsIntoLayer = false
    }
    
    internal func _shapeNeedsUpdate() {
        needsDisplay = true
    }
    
}

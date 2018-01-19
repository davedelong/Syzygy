//
//  ShapeView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class ShapeView: PlatformView {
    
    private lazy var shapeLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        #if os(macOS)
            layerContentsRedrawPolicy = .onSetNeedsDisplay
            canDrawSubviewsIntoLayer = false
        #endif
        
        let layer = self.layer !! "ShapeView is missing its layer"
        l.frame = layer.bounds
        layer.addSublayer(l)
        return l
    }()
    
    private func shapeNeedsUpdate() {
        #if os(macOS)
        needsDisplay = true
        #else
        setNeedsUpdateConstraints()
        #endif
    }
    
    public var lineWidth: CGFloat = 1 {
        didSet { shapeNeedsUpdate() }
    }
    
    public var lineColor: Color? {
        didSet { shapeNeedsUpdate() }
    }
    
    public var shapeInsets: CGEdgeInsets = .zero {
        didSet { shapeNeedsUpdate() }
    }
    
    public var shapeColor: Color? {
        didSet { shapeNeedsUpdate() }
    }
    
    public var shape: Shape? {
        didSet { shapeNeedsUpdate() }
    }
    
    private func updateShape() {
        guard let layer = self.layer else { return }
        
        guard let shape = shape else {
            shapeLayer.path = nil
            return
        }
        
        shapeLayer.frame = layer.bounds
        
        let boundingRect = bounds.applying(shapeInsets)
        let path = shape.bezierPath(in: boundingRect)
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = shapeColor?.rawColor
        shapeLayer.strokeColor = lineColor?.rawColor
        shapeLayer.lineWidth = lineWidth
    }
    
    #if os(macOS)
    public override func updateLayer() {
        super.updateLayer()
        updateShape()
    }
    #else
    public override func updateConstraints() {
        super.updateConstraints()
        updateShape()
    }
    #endif
    
}

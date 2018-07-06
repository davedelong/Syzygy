//
//  ShapeView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class ShapeView: PlatformView {
    
    private var maybeLayer: CALayer? { return self.layer }
    
    private lazy var shapeLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        _configureLayer()
        
        let layer = self.maybeLayer !! "ShapeView is missing its layer"
        l.frame = layer.bounds
        layer.addSublayer(l)
        return l
    }()
    
    public var lineWidth: CGFloat = 1 {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var lineColor: Color? {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var shapeInsets: PlatformEdgeInsets = PlatformEdgeInsets() {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var shapeColor: Color? {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var shape: Shape? {
        didSet { _shapeNeedsUpdate() }
    }
    
    private func updateShape() {
        guard let layer = self.maybeLayer else { return }
        
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
    
    public override func updateLayer() {
        super.updateLayer()
        updateShape()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        updateShape()
    }
    
}

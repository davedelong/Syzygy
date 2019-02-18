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
    
    public var lineColor: PlatformColor? {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var shapeInsets: PlatformEdgeInsets = PlatformEdgeInsets() {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var shapeColor: PlatformColor? {
        didSet { _shapeNeedsUpdate() }
    }
    
    public var shape: Shape? {
        didSet { _shapeNeedsUpdate() }
    }
    
    private func updateShape() {
        guard let layer = self.maybeLayer else { return }
        
        guard let shape = shape else {
            shapeLayer.path = nil
//            layer.mask = nil
            return
        }
        
        
        shapeLayer.frame = layer.bounds
        
        let boundingRect = bounds.applying(shapeInsets)
        let path = shape.bezierPath(in: boundingRect)
        let p = path.CGPath
        shapeLayer.path = p
        shapeLayer.fillColor = shapeColor?.cgColor
        shapeLayer.strokeColor = lineColor?.cgColor
        shapeLayer.lineWidth = lineWidth
        
//        let mask = CAShapeLayer()
//        mask.frame = layer.bounds
//        mask.path = p
//        mask.fillColor = UIColor.black.cgColor
//        mask.strokeColor = UIColor.black.cgColor
//        mask.lineWidth = lineWidth
//        layer.mask = mask
    }
    
    #if BUILDING_FOR_MOBILE
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShape()
    }
    #endif
    
    public override func updateLayer() {
        super.updateLayer()
        updateShape()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        updateShape()
    }
    
    public override func didAddSubview(_ subview: PlatformView) {
        super.didAddSubview(subview)

        platformLayer?.insertSublayer(shapeLayer, at: 0)
    }
    
}

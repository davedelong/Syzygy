//
//  AffineTransform.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public extension AffineTransform {
    
    public init(_ cg: CGAffineTransform) {
        self.init(m11: cg.a, m12: cg.b, m21: cg.c, m22: cg.d, tX: cg.tx, tY: cg.ty)
    }
    
    public var cgAffineTransform: CGAffineTransform {
        return CGAffineTransform(a: m11, b: m12, c: m21, d: m22, tx: tX, ty: tY)
    }
    
}

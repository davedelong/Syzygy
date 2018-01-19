//
//  AffineTransform.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)

public extension AffineTransform {
    
    public init(_ cg: CGAffineTransform) {
        m11 = cg.a
        m12 = cg.b
        m21 = cg.c
        m22 = cg.d
        tX = cg.tx
        tY = cg.ty
    }
    
    public var cgAffineTransform: CGAffineTransform {
        var cg = CGAffineTransform()
        cg.a = m11
        cg.b = m12
        cg.c = m21
        cg.d = m22
        cg.tx = tX
        cg.ty = tY
        return cg
    }
    
}
    
#endif

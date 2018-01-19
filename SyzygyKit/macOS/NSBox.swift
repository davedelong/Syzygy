//
//  NSBox.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)
    
public extension NSBox {
    public enum Orientation {
        case vertical
        case horizontal
    }
    
    public convenience init(separator: Orientation) {
        let w: CGFloat = separator == .horizontal ? 100 : 1
        let h: CGFloat = separator == .vertical ? 100 : 1
        
        let f = NSRect(x: 0, y: 0, width: w, height: h)
        self.init(frame: f)
        self.boxType = .separator
    }
    
}

#endif

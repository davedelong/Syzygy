//
//  NSImage.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//
    
public extension NSImage {
    
    public func resizing(to newSize: NSSize) -> NSImage {
        return NSImage(size: newSize, flipped: false, drawingHandler: {
            self.draw(in: $0)
            return true
        })
    }
        
}

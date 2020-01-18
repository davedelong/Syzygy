//
//  NSImage.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public typealias PlatformImage = NSImage

extension NSImage: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> NSImage? {
        return NSImage(named: name)
    }
}
    
public extension NSImage {
    
    func resizing(to newSize: NSSize) -> NSImage {
        return NSImage(size: newSize, flipped: false, drawingHandler: {
            self.draw(in: $0)
            return true
        })
    }
        
}

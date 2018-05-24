//
//  NSView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Cocoa

public extension NSView {
    
    public func firstSubview<T: NSView>(of type: T.Self = T) -> T? {
        guard let match = subview(where: { $0 is T }, recurses: true) else { return nil }
        return match as? T
    }
    
    public func subview(where matches: (NSView) -> Bool, recurses: Bool = true) -> NSView? {
        for subview in subviews {
            if matches(subview) { return subview }
            if recurses {
                if let match = subview.subview(where: matches, recurses: recurses) { return match }
            }
        }
        return nil
    }
    
    
}

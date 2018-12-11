//
//  NSAttributedString.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public func +=(lhs: inout NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.append(rhs)
}

public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let m = lhs.mutableCopy() as! NSMutableAttributedString
    m.append(rhs)
    return m
}

public extension NSAttributedString {
    
    public func firstRange(of attribute: NSAttributedString.Key) -> NSRange? {
        var returnValue: NSRange?
        let r = NSRange(location: 0, length: length)
        self.enumerateAttribute(attribute, in: r, options: []) { (_, range, stop) in
            returnValue = range
            stop.pointee = true
        }
        return returnValue
    }
    
}

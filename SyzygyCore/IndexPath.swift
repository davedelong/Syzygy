//
//  IndexPath.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension IndexPath {
    
    func hasPrefix(_ other: IndexPath) -> Bool {
        guard (other as NSIndexPath).length <= count else { return false }
        
        let sub = self[0 ..< (other as NSIndexPath).length]
        return sub == other
    }
    
    func hasSuffix(_ other: IndexPath) -> Bool {
        guard (other as NSIndexPath).length <= count else { return false }
        
        let offset = count - (other as NSIndexPath).length
        let sub = self[offset ..< count]
        return sub == other
    }
    
    subscript(range: Range<Int>) -> IndexPath {
        get {
            let myRange = 0 ..< count
            guard myRange.startIndex <= range.lowerBound && myRange.endIndex >= range.upperBound else { return IndexPath() }
            guard range.upperBound >= range.lowerBound else { return IndexPath() } // don't handle backwards ranges
            
            let nsRange = NSMakeRange(range.lowerBound, range.upperBound - range.lowerBound)
            
            var indexes = Array<Int>()
            let nsIndexPath = self as NSIndexPath
            nsIndexPath.getIndexes(&indexes, range: nsRange)
            
            return IndexPath(indexes: indexes)
        }
    }
    
    #if os(macOS)
    
    public var row: Int {
        get { return self.item }
        set { self.item = newValue }
    }
    
    public init(row: Int, section: Int) {
        self.init(item: row, section: section)
    }
    
    #endif
    
}

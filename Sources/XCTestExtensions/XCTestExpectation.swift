//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import XCTest
import ObjectiveC

private var XCTestExpectation_File: UInt8 = 0
private var XCTestExpectation_Line: UInt8 = 0

extension XCTestExpectation {
    
    internal var expectationFile: String? {
        get { return objc_getAssociatedObject(self, &XCTestExpectation_File) as? String }
        set { objc_setAssociatedObject(self, &XCTestExpectation_File, newValue as NSString?, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    internal var expectationLine: Int? {
        get { return objc_getAssociatedObject(self, &XCTestExpectation_Line) as? Int }
        set { objc_setAssociatedObject(self, &XCTestExpectation_Line, newValue as NSNumber?, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    @discardableResult
    public func inverted() -> XCTestExpectation {
        isInverted = !isInverted
        return self
    }
    
    public func invert() {
        isInverted = !isInverted
    }
    
}

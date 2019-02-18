//
//  Markers.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public enum Abort {
    
    public struct Reason: CustomDebugStringConvertible {
        
        public static let shutUpXcode = Reason("Xcode requires this dead code")
        public static let mustBeOverridden = Reason("This method must be overridden")
        public static let unreachable = Reason("This code should be unreachable")
        public static let notYetImplemented = Reason("This code has not been implemented yet")
        public static let invalidLogic = Reason("Invalid logic resulted in a failed condition")
        
        public let debugDescription: String
        public init(_ why: String) {
            self.debugDescription = why
        }
    }
    
    public static func because(_ reason: Reason, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) -> Never {
        because(reason.debugDescription, file: file, line: line, function: function)
    }
    
    public static func because(_ reason: String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) -> Never {
        let message = "Failed assertion in \(function) - \(reason)"
        fatalError(message, file: file, line: line)
    }
    
    public static func `if`(_ condition: @autoclosure () -> Bool, because reason: Reason, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        if condition() == true {
            Abort.because(reason, file: file, line: line, function: function)
        }
    }
    
}

public struct Assert {
    
    public static func isMainThread(_ file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        guard Thread.isMainThread else {
            Abort.because("This may only be executed on the main thread", file: file, line: line, function: function)
        }
    }
    
    public static func that(_ condition: @autoclosure () -> Bool, because: Abort.Reason, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        guard condition() == true else {
            Abort.because(because, file: file, line: line, function: function)
        }
    }
    
    public static func that(_ condition: @autoclosure () -> Bool, because: String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        that(condition, because: Abort.Reason(because), file: file, line: line, function: function)
    }
    
}

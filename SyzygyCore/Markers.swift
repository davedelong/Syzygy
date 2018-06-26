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
    
}

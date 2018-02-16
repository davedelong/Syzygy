//
//  Markers.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public struct Die {
    
    public static func shutUpXcode(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
        die(reason: "Xcode makes me put in \(#function)", extra: nil, file: file, line: line)
    }

    public static func mustOverride(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
        die(reason: "Must be overridden", extra: String(describing: function), file: file, line: line)
    }

    public static func unreachable(_ why: String, file: StaticString = #file, line: UInt = #line) -> Never {
        die(reason: "Unreachable", extra: why, file: file, line: line)
    }

    public static func notImplemented(_ why: String? = nil, file: StaticString = #file, line: UInt = #line) -> Never {
        die(reason: "Not Implemented", extra: why, file: file, line: line)
    }
    
    @available(*, unavailable, renamed: "notImplemented")
    public static func unimplemented(_ why: String? = nil, file: StaticString = #file, line: UInt = #line) -> Never {
        notImplemented(why, file: file, line: line)
    }

    public static func require(_ why: String? = nil, file: StaticString = #file, line: UInt = #line) -> Never {
        die(reason: "Assertion failed", extra: why, file: file, line: line)
    }

    public static func TODO(_ reason: String? = nil, file: StaticString = #file, line: UInt = #line) -> Never {
        die(reason: "Not yet implemented", extra: reason, file: file, line: line)
    }

    private static func die(reason: String, extra: String?, file: StaticString, line: UInt) -> Never {
        var message = reason
        if let extra = extra {
            message += ": \(extra)"
        }
        fatalError(message, file: file, line: line)
    }

}

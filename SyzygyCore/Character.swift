//
//  Character.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Character {
    
    public var isDigit: Bool {
        switch self {
            case "0"..."9": return true
            default: return false
        }
    }
    
    public var isOctalDigit: Bool {
        switch self {
            case "0"..."7": return true
            default: return false
        }
    }
    
    public var isHexDigit: Bool {
        switch self {
            case "a"..."f": return true
            case "A"..."F": return true
            default: return isDigit
        }
    }
    
    public var isAlphabetic: Bool {
        switch self {
            case "a"..."z": return true
            case "A"..."Z": return true
            default: return false
        }
    }
    
    public var isAlphaNumeric: Bool {
        return isAlphabetic || isDigit
    }
    
    public var isNewline: Bool {
        switch self {
            // From CoreFoundation/CFUniChar.c:301
            // http://www.opensource.apple.com/source/CF/CF-1151.16/CFUniChar.c
            case "\u{000a}"..."\u{000d}": return true
            case "\u{0085}": return true
            case "\u{2028}": return true
            case "\u{2029}": return true
            default: return false
        }
    }
    
    public var isWhitespace: Bool {
        switch self {
            // From CoreFoundation/CFUniChar.c:297
            // http://www.opensource.apple.com/source/CF/CF-1151.16/CFUniChar.c
            case "\u{0020}": return true
            case "\u{0009}": return true
            case "\u{00a0}": return true
            case "\u{1680}": return true
            case "\u{2000}"..."\u{200b}": return true
            case "\u{202f}": return true
            case "\u{205f}": return true
            case "\u{3000}": return true
            default: return false
        }
    }
    
    public var isWhitespaceOrNewline: Bool {
        return isWhitespace || isNewline
    }
    
    public var isSuperscript: Bool {
        switch self {
            case "\u{00B2}": return true
            case "\u{00B3}": return true
            case "\u{00B9}": return true
            case "\u{2070}"..."\u{207F}": return true
            default: return false
        }
    }
    
}

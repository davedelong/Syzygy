//
//  Character.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Character {
    
    var isDigit: Bool {
        switch self {
            case "0"..."9": return true
            default: return false
        }
    }
    
    var isOctalDigit: Bool {
        switch self {
            case "0"..."7": return true
            default: return false
        }
    }
    
    var isAlphabetic: Bool {
        switch self {
            case "a"..."z": return true
            case "A"..."Z": return true
            default: return false
        }
    }
    
    var isAlphaNumeric: Bool {
        return isAlphabetic || isDigit
    }
    
    var isWhitespaceOrNewline: Bool {
        return isWhitespace || isNewline
    }
    
    var isSuperscript: Bool {
        switch self {
            case "\u{00B2}": return true
            case "\u{00B3}": return true
            case "\u{00B9}": return true
            case "\u{2070}"..."\u{207F}": return true
            default: return false
        }
    }
    
}

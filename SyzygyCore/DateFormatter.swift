//
//  DateFormatter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 5/20/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension NSAttributedStringKey {
    
    /// Strings created by `DateFormatter.annotatedString(from:)` use this
    /// key to indicate which subranges of the string correspond to particular
    /// date component kinds.
    static let dateComponentKind = NSAttributedStringKey(rawValue: "DateComponentKind")
}

/// The kind of units that a formatted date may contain.
/// - note: These are different from `Calendar.Component`, because
///   that type only provides abstractions. The values in this enum
///   correspond to the various non-skeleton format characters in TR35
public enum DateComponentKind {
    case era
    case year
    case month
    case day
    case dayOfYear
    case julianDay
    case hour
    case minute
    case second
    case nanosecond
    case period
    case weekday
    case quarter
    case timeZone
    case weekOfMonth
    case weekOfYear
    case weekdayOrdinal
    case yearForWeekOfYear
}

fileprivate let FormatMappings: Dictionary<Character, DateComponentKind> = [
    "G": .era,
    "y": .year,
    "Y": .year,
    "u": .year,
    "U": .year,
    "r": .year,
    "Q": .quarter,
    "q": .quarter,
    "M": .month,
    "L": .month,
    "w": .weekOfYear,
    "W": .weekOfMonth,
    "d": .day,
    "D": .dayOfYear,
    "F": .weekdayOrdinal,
    "g": .julianDay,
    "E": .weekday,
    "e": .weekday,
    "c": .weekday,
    "a": .period,
    "b": .period,
    "B": .period,
    "h": .hour,
    "H": .hour,
    "k": .hour,
    "K": .hour,
    "m": .minute,
    "s": .second,
    "S": .nanosecond,
    "z": .timeZone,
    "Z": .timeZone,
    "O": .timeZone,
    "v": .timeZone,
    "V": .timeZone,
    "X": .timeZone,
    "x": .timeZone
]

fileprivate let LiteralCharacter: Character = "'"

private func enumerateFormatPieces(dateFormat: String, enumerator: (String, DateComponentKind?, UnsafeMutablePointer<Bool>) -> Void) {
    
    var currentPiece: String?
    var currentCharacter: Character?
    var currentAttribute: DateComponentKind?
    
    var isInsideLiteral = false
    
    var stop = false
    for character in dateFormat {
        if stop == true { break }
        
        isInsideLiteral = (character == LiteralCharacter ? !isInsideLiteral : isInsideLiteral)
        if character == currentCharacter {
            // same format character as before
            currentPiece = (currentPiece ?? "") + String(character)
        } else {
            if let piece = currentPiece, let char = currentCharacter, char != LiteralCharacter {
                enumerator(piece, currentAttribute, &stop)
            }
            
            currentPiece = String(character)
            currentCharacter = character
        }
        
        if !isInsideLiteral {
            currentAttribute = FormatMappings[character]
        } else {
            currentAttribute = nil
        }
    }
    
    if let current = currentPiece, stop == false {
        enumerator(current, currentAttribute, &stop)
    }
}

public extension DateFormatter {
    
    public func annotatedString(from date: Date) -> NSAttributedString {
        let formatted = string(from: date) as NSString
        let attributed = NSMutableAttributedString(string: formatted as String)
        
        var remainingRange = NSRange(location: 0, length: formatted.length)
        enumerateFormatPieces(dateFormat: self.dateFormat) { (piece, kind, stop) in
            let thisPiece: String
            if kind != nil {
                // this can be very expensive. It might be wise to have a date formatter cache. oh well.
                let df = copy() as! DateFormatter
                df.dateFormat = piece
                thisPiece = df.string(from: date)
            } else {
                thisPiece = piece
            }
            
            let rangeOfThisPiece = formatted.range(of: thisPiece, options: [], range: remainingRange)
            if rangeOfThisPiece.location == NSNotFound {
                stop.pointee = true
                return
            }
            
            remainingRange = NSRange(location: NSMaxRange(rangeOfThisPiece), length: formatted.length - NSMaxRange(rangeOfThisPiece))
            if let k = kind {
                attributed.addAttribute(.dateComponentKind, value: k, range: rangeOfThisPiece)
            }
        }
        return attributed
    }
    
}

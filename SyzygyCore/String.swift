//
//  String.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension String: ReferenceConvertible {
    public typealias ReferenceType = NSString
}

public extension String {
    
    func append(pathComponents components: String ...) -> String {
        var ns = self as NSString
        for component in components {
            ns = ns.appendingPathComponent(component) as NSString
        }
        return ns as String
    }
    
    mutating func removingLastCharacter() {
        let last = endIndex
        let penultimate = self.index(before: last)
        self.removeSubrange(penultimate ..< last)
    }
    
    func removePrefix(_ prefix: String) -> String {
        guard let prefixRange = range(of: prefix) else { return self }
        guard prefixRange.upperBound < endIndex else { return self }
        return String(self[prefixRange.upperBound..<endIndex])
    }
    
    func removeSuffix(_ suffix: String) -> String {
        guard let suffixRange = range(of: suffix, options: .backwards) else { return self }
        guard suffixRange.lowerBound < endIndex else { return self }
        return String(self[startIndex..<suffixRange.lowerBound])
    }
    
    func longestCommonPrefix(_ with: String) -> String {
        return String.longestCommonPrefix([self, with])
    }
    
    func split(by characterSet: CharacterSet) -> Array<String> {
        let scalars = self.unicodeScalars
        var final = Array<String>()
        
        var current: String?
        for scalar in scalars {
            let isSplit = characterSet.contains(scalar)
            switch (isSplit, current) {
                    
                case (true, nil):
                    current = String(scalar)
                case (true, .some(let c)):
                    final.append(c)
                    current = String(scalar)
                    
                case (false, nil):
                    current = String(scalar)
                case (false, .some(_)):
                    current?.append(String(scalar))
            }
        }
        
        if let c = current {
            final.append(c)
        }
        
        return final
    }
    
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func longestCommonPrefix(_ candidates: Array<String>) -> String {
        guard candidates.isEmpty == false else { return "" }
        
        let characterArrays = candidates.map { Array($0) }
        
        for prefixLen in 0 ..< characterArrays[0].count {
            let character = characterArrays[0][prefixLen]
            for i in 1 ..< characterArrays.count {
                if prefixLen >= characterArrays[i].count || characterArrays[i][prefixLen] != character {
                    // Mismatch found
                    return String(characterArrays[i][0..<prefixLen])
                }
            }
        }
        return candidates[0]
    }
    
    func matches<C: Collection>(any: C) -> Bool where C.Element: StringProtocol {
        for item in any {
            if self.localizedCaseInsensitiveContains(item) { return true }
        }
        return false
    }
    
    func matches<C: Collection>(all: C) -> Bool where C.Element: StringProtocol {
        for item in all {
            if self.localizedCaseInsensitiveContains(item) == false { return false }
        }
        return true
    }
    
    func extractTerms() -> Array<String> {
        var terms = Array<String>()
        var current = ""
        
        var isCurrentlyEscaping = false
        var isInsideQuote = false
        
        for nextIndex in indices {
            let c = self[nextIndex]
            
            if isCurrentlyEscaping {
                isCurrentlyEscaping = false
                current.append(c)
            } else if c == "\\" {
                isCurrentlyEscaping = true
            } else if c == "\"" {
                if isInsideQuote {
                    terms.append(current)
                    current = ""
                }
                isInsideQuote.toggle()
            } else if isInsideQuote {
                current.append(c)
            } else if c.isWhitespace == false {
                current.append(c)
            } else {
                // it's whitespace
                if current.isEmpty == false {
                    terms.append(current)
                }
                current = ""
            }
        }
        if current.isEmpty == false {
            terms.append(current)
        }
        return terms
    }
    
    func tokenize() -> AnyPredicate<String> {
        let terms = self.extractTerms()
        guard terms.isEmpty == false else { return .true }
        
        let predicates = terms.map { t -> AnyPredicate<String> in
            
            let p: AnyPredicate<String>
            if t.hasPrefix("-") == false {
                p = AnyPredicate<String> { s in
                    return s.localizedCaseInsensitiveContains(t) == true
                }
            } else {
                let remainder = t.dropFirst()
                p = AnyPredicate<String> { s -> Bool in
                    return s.localizedCaseInsensitiveContains(remainder) == false
                }
            }
            return p
        }
        
        let anded = AndPredicate(predicates)
        return AnyPredicate(anded)
    }
    
}

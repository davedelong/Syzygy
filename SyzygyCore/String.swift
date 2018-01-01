//
//  String.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

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
    
    func splitting(by characterSet: CharacterSet) -> Array<String> {
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
    
}

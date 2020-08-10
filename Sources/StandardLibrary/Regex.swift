//
//  Regex.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public struct Regex {
    
    private let pattern: NSRegularExpression
    
    public init(_ pattern: StaticString, options: NSRegularExpression.Options = []) {
        self.pattern = try! NSRegularExpression(pattern: "\(pattern)", options: options)
    }
    
    public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        self.pattern = try NSRegularExpression(pattern: pattern, options: options)
    }
    
    public func matches(_ string: String) -> Bool  {
        let range = NSRange(location: 0, length: string.utf16.count)
        return pattern.numberOfMatches(in: string, options: [.withTransparentBounds], range: range) > 0
    }
    
    public func match(_ string: String) -> RegexMatch? {
        let range = NSRange(location: 0, length: string.utf16.count)
        guard let match = pattern.firstMatch(in: string, options: [.withTransparentBounds], range: range) else { return nil }
        return RegexMatch(result: match, source: string)
    }
    
    public func matches(in string: String) -> Array<RegexMatch> {
        var matches = Array<RegexMatch>()
        
        let range = NSRange(location: 0, length: string.utf16.count)
        pattern.enumerateMatches(in: string, options: [], range: range) { (result, flags, stop) in
            if let result = result {
                let match = RegexMatch(result: result, source: string)
                matches.append(match)
            }
        }
        
        return matches
    }
}

extension Regex: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) { self.init(value) }
    public init(extendedGraphemeClusterLiteral value: StaticString) { self.init(value) }
    public init(unicodeScalarLiteral value: StaticString) { self.init(value) }
}

public struct RegexMatch {
    private let matches: Array<String?>
    
    fileprivate init(result: NSTextCheckingResult, source: String) {
        let nsSource = source as NSString
        
        var matches = Array<String?>()
        for i in 0 ..< result.numberOfRanges {
            let r = result.range(at: i)
            if r.location == NSNotFound {
                matches.append(nil)
            } else {
                matches.append(nsSource.substring(with: r))
            }
        }
        
        self.matches = matches
    }
    
    public subscript(index: Int) -> String? {
        get {
            return matches[index]
        }
    }
}

public func ~= (left: Regex, right: String) -> Bool {
    return left.matches(right)
}

public func ~= (left: Regex, right: String) -> RegexMatch? {
    return left.match(right)
}

public extension String {
    
    func matches(regex: String) -> Bool {
        guard let r = try? Regex(pattern: regex) else { return false }
        return r.matches(self)
    }
    
    func matches(regex: Regex) -> Bool {
        return regex.matches(self)
    }
    
    func match(regex: String) -> RegexMatch? {
        guard let r = try? Regex(pattern: regex) else { return nil }
        return r.match(self)
    }
    
    func match(regex: Regex) -> RegexMatch? {
        return regex.match(self)
    }
    
}

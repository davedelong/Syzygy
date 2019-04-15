//
//  Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public enum PathComponent: Hashable {
    case this
    case up
    case item(String, String?)
        
    public init(_ string: String) {
        switch string {
            case ".": self = .this
            case "..": self = .up
            default:
                var ext: String? = (string as NSString).pathExtension
                if ext?.isEmpty == true { ext = nil }
                
                let name = (string as NSString).deletingPathExtension
                self = .item(name, ext)
        }
    }
    
    internal var asString: String {
        switch self {
            case .this: return "."
            case .up: return ".."
            case .item(let s, let se):
                if let se = se {
                    return s + "." + se
                }
                return s
        }
    }
    
    internal var itemString: String? {
        guard case .item(_) = self else { return nil }
        return asString
    }
}

public protocol Path: Hashable, CustomDebugStringConvertible {
    
    var components: Array<PathComponent> { get }
    var fileSystemPath: String { get }
    
    init(_ components: Array<PathComponent>)
    
}

public let PathSeparator = "/"

public extension Path {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.components == rhs.components
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(components.count)
    }
    
    var debugDescription: String {
        return fileSystemPath
    }
    
    var lastComponent: PathComponent? { return components.last }
    var lastItem: String? { return components.last?.itemString }
    
    var `extension`: String? {
        guard case .some(.item(_, let e)) = components.last else { return nil }
        return e
    }
    
    func modifyingLastItem(_ modifier: (String, String?) -> (String, String?)?) -> Self {
        var pieces = self.components
        guard case .some(.item(let s, let e)) = pieces.popLast() else { return self }
        if let (name, ext) = modifier(s, e) {
            pieces.append(.item(name, ext))
        }
        return Self.init(pieces)
    }
    
    func deletingExtension() -> Self {
        return modifyingLastItem { (s, _) in return (s, nil) }
    }
    
    func deletingLastComponent() -> Self {
        return modifyingLastItem { (_, _) in return nil }
    }
    
    func trimming(_ path: RelativePath) -> Self {
        var pieces = self.components
        var toRemove = path.components
        
        while pieces.isEmpty == false && toRemove.isEmpty == false && pieces.last == toRemove.last {
            _ = pieces.popLast()
            _ = toRemove.popLast()
        }
        return Self.init(pieces)
    }
    
    func deletingFirstComponent() -> Self {
        var pieces = self.components
        _ = pieces.removeFirst()
        return Self.init(pieces)
    }
    
    func appending(components: String...) -> Self {
        let pieces = components.map { PathComponent($0) }
        return Self.init(self.components + pieces)
    }
    
    func appending(component: String) -> Self {
        return Self.init(self.components + [PathComponent(component)])
    }
    
    func appending(component: PathComponent) -> Self {
        return Self.init(self.components + [component])
    }
    
    func appending(path: RelativePath) -> Self {
        return Self.init(self.components + path.components)
    }
    
    func appending(extension ext: String) -> Self {
        return modifyingLastItem { (n, e) in
            guard let existing = e else { return (n, ext) }
            guard let last = (n as NSString).appendingPathExtension(existing) else { return (n, e) }
            return (last, ext)
        }
    }
    
    func appending(lastItemPiece piece: String) -> Self {
        return modifyingLastItem { ($0+piece, $1) }
    }
    
    func replacingLast(extension ext: String) -> Self {
        return modifyingLastItem { (s, _) in return (s, ext) }
    }
    
    func containedWithin(name: String? = nil, extensions: Set<String>? = nil) -> Bool {
        if name == nil && `extension` == nil { return true }
        
        let nameMatcher: (String) -> Bool
        if let n = name {
            nameMatcher = { $0 == n }
        } else {
            nameMatcher = { _ in true }
        }
        
        let extMatcher: (String?) -> Bool
        if let e = extensions {
            extMatcher = { $0.map { e.contains($0) } ?? false }
        } else {
            extMatcher = { _ in true }
        }
        
        for component in components.dropLast() {
            switch component {
                case .item(let n, let e):
                    if nameMatcher(n) && extMatcher(e) { return true }
                
                default: continue
            }
        }
        return false
    }
    
}

prefix operator /
infix operator /: MultiplicationPrecedence

public func +<P: Path>(lhs: P, rhs: RelativePath) -> P {
    return lhs.appending(path: rhs)
}

public func +<P: Path>(lhs: P, rhs: String) -> P {
    return lhs.appending(component: PathComponent(rhs))
}

public func /<P: Path>(lhs: P, rhs: RelativePath) -> P {
    return lhs.appending(path: rhs)
}

public func /<P: Path>(lhs: P, rhs: String) -> P {
    return lhs.appending(component: rhs)
}

public prefix func /(rhs: RelativePath) -> AbsolutePath {
    return AbsolutePath(rhs.components)
}

public prefix func /(rhs: String) -> AbsolutePath {
    return AbsolutePath([PathComponent(rhs)])
}

internal func reduce(_ components: Array<PathComponent>, allowRelative: Bool) -> Array<PathComponent> {
    var newComponents = Array<PathComponent>()
    for c in components {
        switch c {
            case .this:
                continue
            case .up:
                if newComponents.isEmpty == false {
                    newComponents.removeLast()
                } else if allowRelative == true {
                    newComponents.append(c)
                }
            case .item(let s, let e):
                if s == PathSeparator && e == nil {
                    continue
                } else if s.hasPrefix("~") && e == nil {
                    newComponents.removeAll()
                    let expanded = AbsolutePath(fileSystemPath: s)
                    newComponents.append(contentsOf: expanded.components)
                } else {
                    newComponents.append(c)
                }
        }
    }
    return newComponents
}

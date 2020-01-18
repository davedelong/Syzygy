//
//  AbsolutePath.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public struct AbsolutePath: Path {
    
    public static let root = AbsolutePath([])
    public static let temporaryDirectory = AbsolutePath(fileSystemPath: NSTemporaryDirectory())
    
    public let components: Array<PathComponent>
    
    public var fileSystemPath: String {
        return PathSeparator + components.map { $0.asString }.joined(separator: PathSeparator)
    }
    
    public var fileURL: URL {
        return URL(fileURLWithPath: fileSystemPath)
    }
    
    public init(_ components: Array<PathComponent>) {
        self.components = reduce(components, allowRelative: false)
    }
    
    public init(_ url: URL) {
        let pathComponents = url.pathComponents.filter { $0 != PathSeparator }
        self.init(pathComponents.map { PathComponent($0) })
    }
    
    public init(fileSystemPath: StaticString) {
        let asString = String(describing: fileSystemPath)
        self.init(fileSystemPath: asString)
    }
    
    public init(fileSystemPath: String) {
        let expanded = (fileSystemPath as NSString).expandingTildeInPath
        let pieces = (expanded as NSString).pathComponents.filter { $0 != PathSeparator }
        self.init(pieces.map { PathComponent($0) })
    }
    
    public func resolvingSymlinks() -> AbsolutePath {
        let resolvedURL = fileURL.resolvingSymlinksInPath()
        return AbsolutePath(resolvedURL)
    }
    
    public func extendedAttribute(named: String) -> Data? {
        let path = fileSystemPath
        let length = getxattr(path, named, nil, 0, 0, 0)
        if length < 0 { return nil }
        
        let data = NSMutableData(length: length)!
        if getxattr(path, named, data.mutableBytes, length, 0, 0) >= 0 {
            return data as Data
        } else {
            return nil
        }
    }
    
    public func setExtendedAttribute(named: String, value: Data?) {
        if let data = value {
            let nsData = data as NSData
            setxattr(fileSystemPath, named, nsData.bytes, nsData.length, 0, 0)
        } else {
            removexattr(fileSystemPath, named, 0)
        }
    }
    
    public func relativeTo(_ start: AbsolutePath) -> RelativePath {
        var startComponents = start.components
        var destComponents = self.components
        
        while let s = startComponents.first, let d = destComponents.first, s == d {
            startComponents.removeFirst()
            destComponents.removeFirst()
        }
        
        let ups = Array(repeating: PathComponent.up, count: startComponents.count)
        var final = ups + destComponents
        
        if final.isEmpty { final = [.this] }
        
        return RelativePath(final, shouldReduce: false)
    }
}

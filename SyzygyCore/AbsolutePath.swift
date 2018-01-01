//
//  AbsolutePath.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

private func appSpecificDirectory(directory: FileManager.SearchPathDirectory) -> AbsolutePath {
    let fm = FileManager.default
    let folder = try! fm.path(for: directory)
    let id = Bundle.main.name
    let appFolder = folder.appending(component: id)
    if fm.folderExists(atPath: appFolder) == false {
        try? fm.createDirectory(at: appFolder)
    }
    return appFolder
}

private let appCacheDirectory: AbsolutePath = { return appSpecificDirectory(directory: .cachesDirectory) }()
private let appSupportDirectory: AbsolutePath = { return appSpecificDirectory(directory: .applicationSupportDirectory) }()

public struct AbsolutePath: Path {
    
    public static let root = AbsolutePath([])
    public static let temporaryDirectory = AbsolutePath(fileSystemPath: NSTemporaryDirectory())
    public static var applicationCacheDirectory: AbsolutePath { return appCacheDirectory }
    public static var applicationSupportDirectory: AbsolutePath { return appSupportDirectory }
    
    public let components: Array<PathComponent>
    
    public var fileSystemPath: String {
        return PathSeparator + components.map { $0.asString }.joined(separator: PathSeparator)
    }
    
    public var fileURL: URL {
        return URL(fileURLWithPath: fileSystemPath)
    }
    
    public var bookmarkData: Data? {
        return fileURL.bookmarkData
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
    
    public init?(bookmarkData: Data) {
        guard let url = URL(bookmarkData: bookmarkData) else { return nil }
        self.init(url)
    }
    
    public func resolvingSymlinks() -> AbsolutePath {
        let resolvedURL = fileURL.resolvingSymlinksInPath()
        return AbsolutePath(resolvedURL)
    }
    
    public func contains(_ other: AbsolutePath) -> Bool {
        return fileURL.contains(other.fileURL)
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
    
    /*public func relative(to: AbsolutePath) -> RelativePath {
     var components = Array<PathComponent>()
     
     var thisStack = components
     var targetStack = to.components
     
     while thisStack.isEmpty == false || targetStack.isEmpty == false {
     let thisItem = thisStack.first
     let targetItem = targetStack.first
     
     switch (thisItem, targetItem) {
     case (.none, .none): break
     case (.none, .some(_)): components.append(.up)
     case (.some(let i), .none): components.append(i)
     }
     
     _ = thisStack.removeFirst()
     _ = targetStack.removeFirst()
     }
     
     }*/
}

//
//  FileManager+Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension FileManager {
    
    public struct OpenWith {
        public let applicationPath: AbsolutePath
        public let bundleIdentifier: String
        public let bundleVersion: String
        
        public init(path: AbsolutePath, bundleIdentifier: String, bundleVersion: String) {
            self.applicationPath = path
            self.bundleIdentifier = bundleIdentifier
            self.bundleVersion = bundleVersion
        }
        
        public init(bundle: Bundle) {
            self.applicationPath = bundle.path
            self.bundleIdentifier = bundle.bundleIdentifier !! "Unable to get identifier of bundle \(bundle)"
            self.bundleVersion = bundle.bundleVersion
        }
    }
    
    public func path(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask = .userDomainMask, appropriateFor path: AbsolutePath? = nil, create shouldCreate: Bool = true) throws -> AbsolutePath {
        let result = try self.url(for: directory, in: domain, appropriateFor: path?.fileURL, create: shouldCreate)
        return AbsolutePath(result)
    }
    
    public func pathExists(_ path: AbsolutePath, isDirectory: UnsafeMutablePointer<ObjCBool>? = nil) -> Bool {
        return fileExists(atPath: path.fileSystemPath, isDirectory: isDirectory)
    }
    
    public func folderExists(atPath path: AbsolutePath) -> Bool {
        var isFolder: ObjCBool = false
        let exists = pathExists(path, isDirectory: &isFolder)
        return exists && isFolder.boolValue
    }
    
    public func fileExists(atPath path: AbsolutePath) -> Bool {
        var isFolder: ObjCBool = false
        let exists = pathExists(path, isDirectory: &isFolder)
        return exists && !isFolder.boolValue
    }
    
    public func copyItem(at path: AbsolutePath, to newPath: AbsolutePath) throws {
        try copyItem(at: path.fileURL, to: newPath.fileURL)
    }
    
    @discardableResult
    public func createFile(atPath path: AbsolutePath, contents: Data? = nil, attributes: Dictionary<FileAttributeKey, Any>? = nil) -> Bool {
        return createFile(atPath: path.fileSystemPath, contents: contents, attributes: attributes)
    }
    
    public func createDirectory(at path: AbsolutePath, withIntermediateDirectories: Bool = true, attributes: Dictionary<FileAttributeKey, Any>? = nil) throws {
        try createDirectory(at: path.fileURL, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }
    
    public func relativeContentsOfDirectory(at path: RelativePath, relativeTo: AbsolutePath) -> Array<RelativePath> {
        let absolute = relativeTo + path
        guard let children = try? self.contentsOfDirectory(atPath: absolute.fileSystemPath) else { return [] }
        return children.map { path + $0 }
    }
    
    public func relativeContentsOfDirectory(at path: AbsolutePath) -> Array<RelativePath> {
        guard let children = try? self.contentsOfDirectory(atPath: path.fileSystemPath) else { return [] }
        return children.map { RelativePath($0) }
    }
    
    public func contentsOfDirectory(at path: AbsolutePath, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: FileManager.DirectoryEnumerationOptions = []) -> Array<AbsolutePath> {
        let contents = (try? contentsOfDirectory(at: path.fileURL, includingPropertiesForKeys: keys, options: mask)) ?? []
        return contents.map { AbsolutePath($0) }
    }
    
    public func removeItem(atPath path: AbsolutePath) throws {
        try removeItem(atPath: path.fileSystemPath)
    }
    
    public func moveItem(atPath srcPath: AbsolutePath, toPath dstPath: AbsolutePath) throws {
        try moveItem(atPath: srcPath.fileSystemPath, toPath: dstPath.fileSystemPath)
    }
    
    public func displayName(atPath path: AbsolutePath) -> String {
        return displayName(atPath: path.fileSystemPath)
    }

    public func openFile(_ file: AbsolutePath, with: OpenWith?) {
        guard let openInfo = with else {
            file.setExtendedAttribute(named: "com.apple.LaunchServices.OpenWith", value: nil)
            return
        }
        
        let dictionary: Dictionary<String, Any> = [
            "path": openInfo.applicationPath.fileSystemPath,
            "bundleidentifier": openInfo.bundleIdentifier,
            "bundleversion": openInfo.bundleVersion,
            "version": 0
        ]
        let plist = Plist(dictionary)
        let data = try? plist.plistData(.binary)
        file.setExtendedAttribute(named: "com.apple.LaunchServices.OpenWith", value: data)
    }
    
    public func openWithInfo(for file: AbsolutePath) -> OpenWith? {
        guard let plistData = file.extendedAttribute(named: "com.apple.LaunchServices.OpenWith") else { return nil }
        guard let plist = try? Plist(data: plistData) else { return nil }
        
        guard let path = plist["path"].string else { return nil }
        guard let vers = plist["bundleversion"].string else { return nil }
        guard let bid = plist["bundleidentifier"].string else { return nil }
        
        let p = AbsolutePath(fileSystemPath: path)
        return OpenWith(path: p, bundleIdentifier: bid, bundleVersion: vers)
    }
}

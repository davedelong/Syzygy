//
//  FileManager+Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

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

public extension FileManager {

    static var applicationCacheDirectory: AbsolutePath { return appCacheDirectory }
    static var applicationSupportDirectory: AbsolutePath { return appSupportDirectory }
    
    struct OpenWith {
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
    
    func path(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask = .userDomainMask, appropriateFor path: AbsolutePath? = nil, create shouldCreate: Bool = true) throws -> AbsolutePath {
        let result = try self.url(for: directory, in: domain, appropriateFor: path?.fileURL, create: shouldCreate)
        return AbsolutePath(result)
    }
    
    func pathExists(_ path: AbsolutePath, isDirectory: UnsafeMutablePointer<ObjCBool>? = nil) -> Bool {
        return fileExists(atPath: path.fileSystemPath, isDirectory: isDirectory)
    }
    
    func folderExists(atPath path: String) -> Bool {
        var isFolder: ObjCBool = false
        let exists = fileExists(atPath: path, isDirectory: &isFolder)
        return exists && isFolder.boolValue
    }
    
    func folderExists(atURL url: URL) -> Bool {
        return folderExists(atPath: url.path)
    }
    
    func folderExists(atPath path: AbsolutePath) -> Bool {
        var isFolder: ObjCBool = false
        let exists = pathExists(path, isDirectory: &isFolder)
        return exists && isFolder.boolValue
    }
    
    func fileExists(atPath path: AbsolutePath) -> Bool {
        var isFolder: ObjCBool = false
        let exists = pathExists(path, isDirectory: &isFolder)
        return exists && !isFolder.boolValue
    }
    
    func copyItem(at path: AbsolutePath, to newPath: AbsolutePath) throws {
        try copyItem(at: path.fileURL, to: newPath.fileURL)
    }
    
    @discardableResult
    func createFile(atPath path: AbsolutePath, contents: Data? = nil, attributes: Dictionary<FileAttributeKey, Any>? = nil) -> Bool {
        return createFile(atPath: path.fileSystemPath, contents: contents, attributes: attributes)
    }
    
    func createDirectory(at path: AbsolutePath, withIntermediateDirectories: Bool = true, attributes: Dictionary<FileAttributeKey, Any>? = nil) throws {
        try createDirectory(at: path.fileURL, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }
    
    func relativeContentsOfDirectory(at path: RelativePath, relativeTo: AbsolutePath) -> Array<RelativePath> {
        let absolute = relativeTo + path
        guard let children = try? self.contentsOfDirectory(atPath: absolute.fileSystemPath) else { return [] }
        return children.map { path + $0 }
    }
    
    func relativeContentsOfDirectory(at path: AbsolutePath) -> Array<RelativePath> {
        guard let children = try? self.contentsOfDirectory(atPath: path.fileSystemPath) else { return [] }
        return children.map { RelativePath($0) }
    }
    
    func contentsOfDirectory(at path: AbsolutePath, includingPropertiesForKeys keys: [URLResourceKey]? = nil, options mask: FileManager.DirectoryEnumerationOptions = []) -> Array<AbsolutePath> {
        let contents = (try? contentsOfDirectory(at: path.fileURL, includingPropertiesForKeys: keys, options: mask)) ?? []
        return contents.map { AbsolutePath($0) }
    }
    
    func removeItem(atPath path: AbsolutePath) throws {
        try removeItem(atPath: path.fileSystemPath)
    }
    
    func moveItem(atPath srcPath: AbsolutePath, toPath dstPath: AbsolutePath) throws {
        try moveItem(atPath: srcPath.fileSystemPath, toPath: dstPath.fileSystemPath)
    }
    
    func displayName(atPath path: AbsolutePath) -> String {
        return displayName(atPath: path.fileSystemPath)
    }

    func openFile(_ file: AbsolutePath, with: OpenWith?) {
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
    
    func openWithInfo(for file: AbsolutePath) -> OpenWith? {
        guard let plistData = file.extendedAttribute(named: "com.apple.LaunchServices.OpenWith") else { return nil }
        guard let plist = try? Plist(data: plistData) else { return nil }
        
        guard let path = plist["path"].string else { return nil }
        guard let vers = plist["bundleversion"].string else { return nil }
        guard let bid = plist["bundleidentifier"].string else { return nil }
        
        let p = AbsolutePath(fileSystemPath: path)
        return OpenWith(path: p, bundleIdentifier: bid, bundleVersion: vers)
    }
}

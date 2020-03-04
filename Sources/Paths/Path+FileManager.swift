//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation
import StandardLibrary

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
}

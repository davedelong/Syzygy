//
//  Sandbox.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

import Foundation

public class Sandbox {
    
    private static func group(identifier: String) -> Sandbox {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier) !! "Cannot get container for \(identifier)"
        let docs = container.appendingPathComponent("Documents", isDirectory: true)
        let cache = container.appendingPathComponent("Caches", isDirectory: true)
        let supp = container.appendingPathComponent("Application Support", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: docs, withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(at: cache, withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(at: supp, withIntermediateDirectories: true, attributes: nil)
        
        let defaults = UserDefaults(suiteName: identifier) !! "Cannot get defaults for \(identifier)"
        
        return Sandbox(documents: AbsolutePath(docs), caches: AbsolutePath(cache), support: AbsolutePath(supp), defaults: defaults)
    }
    
    public static let currentProcess: Sandbox = {
        let docs = try! FileManager.default.path(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let cache = try! FileManager.default.path(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let support = try! FileManager.default.path(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return Sandbox(documents: docs, caches: cache, support: support, defaults: UserDefaults.standard)
    }()
    
    public static let sharedGroup = group(identifier: "group.pass-archive")
    
    public let documents: AbsolutePath
    public let caches: AbsolutePath
    public let support: AbsolutePath
    public let temporary: AbsolutePath
    
    public let defaults: UserDefaults
    
    public init(documents: AbsolutePath, caches: AbsolutePath, support: AbsolutePath, defaults: UserDefaults) {
        self.documents = documents
        self.caches = caches
        self.support = support
        self.defaults = defaults
        
        self.temporary = AbsolutePath(fileSystemPath: NSTemporaryDirectory())
    }
    
    public func temporaryPath() -> TemporaryPath {
        return TemporaryPath(in: temporary)
    }
}

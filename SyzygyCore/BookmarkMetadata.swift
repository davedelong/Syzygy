//
//  BookmarkMetadata.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

internal class BookmarkMetadataStore {
    
    static let defaultStore = BookmarkMetadataStore(storageFolder: AbsolutePath.applicationSupportDirectory)
    
    private let storageFolder: AbsolutePath
    private var metadatas = Array<BookmarkMetadata>()
    
    init(storageFolder: AbsolutePath) {
        self.storageFolder = storageFolder.appending(component: "BookmarkMetadatas")
        do {
            try FileManager.default.createDirectory(at: self.storageFolder)
        } catch let e {
            Log.error("Could not create metadata directory: \(e)")
        }
        
        let contents = FileManager.default.contentsOfDirectory(at: self.storageFolder, options: [.skipsSubdirectoryDescendants])
        metadatas = contents.flatMap { BookmarkMetadata(storagePath: $0) }
    }
    
    internal func metadata(for path: AbsolutePath?, createIfNeeded: Bool = true) -> BookmarkMetadata? {
        guard let path = path else { return nil }
        for metadata in metadatas {
            if metadata.path == path { return metadata }
        }
        
        if createIfNeeded == true, let data = path.bookmarkData {
            let m = BookmarkMetadata(bookmark: data, storageFolder: storageFolder)
            metadatas.append(m)
            return m
        }
        
        return nil
    }
    
}

internal class BookmarkMetadata {
    private static let BookmarkDataKey = "##__BOOKMARK__"
    
    private let bookmarkData: Data
    private let storagePath: AbsolutePath
    private var storage: Dictionary<String, Plist> {
        didSet { persist() }
    }
    
    fileprivate var path: AbsolutePath? {
        return AbsolutePath(bookmarkData: bookmarkData)
    }
    
    
    init(bookmark: Data, storageFolder: AbsolutePath) {
        var file: AbsolutePath
        repeat {
            file = storageFolder + (UUID().uuidString + ".metadata")
        } while FileManager.default.pathExists(file)
        
        storagePath = file
        storage = [:]
        bookmarkData = bookmark
    }
    
    init?(storagePath: AbsolutePath) {
        guard let plist = try? Plist(contentsOf: storagePath) else { return nil }
        guard let bData = plist[BookmarkMetadata.BookmarkDataKey].data else { return nil }
        
        self.bookmarkData = bData
        self.storagePath = storagePath
        
        var rawStorage = plist.dictionary ?? [:]
        rawStorage[BookmarkMetadata.BookmarkDataKey] = nil
        self.storage = rawStorage
    }
    
    subscript<T: PlistConvertible>(key: String) -> T? {
        get { return T.init(storage[key]) }
        set { storage[key] = newValue?.plistValue}
    }
    
    private func persist() {
        var final = storage
        final[BookmarkMetadata.BookmarkDataKey] = .data(bookmarkData)
        
        let plist = Plist(final)
        do {
            try plist.write(to: storagePath)
        } catch let e {
            Log.error("Error writing metadata storage: \(e)")
        }
    }
    
}

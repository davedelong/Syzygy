//
//  Bookmark.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public final class Bookmark: Hashable {
    private static let knownBookmarksLock = NSLock()
    private static var knownBookmarks = Array<WeakBox<Bookmark>>()

    public static func `for`(_ path: AbsolutePath) -> Bookmark {
        let bookmark: Bookmark
        knownBookmarksLock.lock()
        
        knownBookmarks = knownBookmarks.filter { $0.value == nil }
        if let existing = knownBookmarks.filter({ $0.value?.path.value == path }).first?.value {
            bookmark = existing
        } else {
            bookmark = Bookmark(path: path)
            knownBookmarks.append(WeakBox(bookmark))
        }
        
        knownBookmarksLock.unlock()
        return bookmark
    }
    
    public static func ==(lhs: Bookmark, rhs: Bookmark) -> Bool {
        let lPath = lhs.path.value
        let rPath = rhs.path.value
        guard lPath != nil || rPath != nil else { return false }
        return lPath == rPath
    }
    
    private let raw: Property<AbsolutePath?>
    public let path: Property<AbsolutePath?>
    public var hashValue: Int { return path.value?.hashValue ?? 0 }
    
    public init(path: AbsolutePath) {
        self.raw = FileManager.default.resolved(path: path)
        self.path = raw.skipRepeats(==)
    }
    
    public convenience init?(bookmarkData: Data) {
        guard let path = AbsolutePath(bookmarkData: bookmarkData) else { return nil }
        self.init(path: path)
    }
    
    private func metadata(_ createIfNeeded: Bool = true) -> BookmarkMetadata? {
        return BookmarkMetadataStore.defaultStore.metadata(for: raw.value, createIfNeeded: createIfNeeded)
    }
    
    public subscript<T: PlistConvertible>(key: String) -> T? {
        get { return metadata(false)?[key] }
        set { metadata(true)?[key] = newValue }
    }
    
}

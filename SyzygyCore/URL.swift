//
//  URL.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Darwin

public extension URL {
    
    init?(phoneNumber: String) {
        let notNumbers = CharacterSet.decimalDigits.inverted
        let cleaned = (phoneNumber as NSString).components(separatedBy: notNumbers).joined()
        guard cleaned.isEmpty == false else { return nil }
        self.init(string: "tel://\(cleaned)")
    }
    
    init?(bookmarkData: Data) {
        var stale: Bool = false
        try? self.init(resolvingBookmarkData: bookmarkData, options: [.withoutUI, .withoutMounting], relativeTo: nil, bookmarkDataIsStale: &stale)
    }
    
    var bookmarkData: Data? {
        return try? self.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
    }
    
    var parent: URL? { return self.deletingLastPathComponent() }
    
    func relationship(to other: URL) -> FileManager.URLRelationship {
        var relationship: FileManager.URLRelationship = .other
        _ = try? FileManager.default.getRelationship(&relationship, ofDirectoryAt: self, toItemAt: other)
        return relationship
    }
    
    func contains(_ other: URL) -> Bool {
        let r = relationship(to: other)
        return (r == .contains || r == .same)
    }
    
    func removing(pathComponents: String...) -> URL {
        return removing(pathComponents: pathComponents)
    }
    
    func removing(pathComponents: Array<String>) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return self }
        
        var finalPath = (components.path as NSString).pathComponents
        var toDelete = pathComponents
        
        while finalPath.isEmpty == false && toDelete.isEmpty == false && finalPath.last == toDelete.last {
            _ = finalPath.popLast()
            _ = toDelete.popLast()
        }
        
        components.path = NSString.path(withComponents: finalPath)
        return components.url ?? self
    }
    
    var isHidden: Bool {
        guard isFileURL else { return false }
        var url = self
        while url.path != "/" {
            if url.path == "/Volumes" { return false }
            let values = try? url.resourceValues(forKeys: [.isHiddenKey])
            if values?.isHidden == true { return true }
            url = url.deletingLastPathComponent()
        }
        return false
    }
    
    var isVisible: Bool { return !isHidden }
}

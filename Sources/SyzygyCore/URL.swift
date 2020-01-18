//
//  URL.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

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
}

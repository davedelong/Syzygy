//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation
import Paths

extension AbsolutePath {
    
    public var bookmarkData: Data? {
        return fileURL.bookmarkData
    }

    
    public init?(bookmarkData: Data) {
        guard let url = URL(bookmarkData: bookmarkData) else { return nil }
        self.init(url)
    }
    
    public func contains(_ other: AbsolutePath) -> Bool {
        return fileURL.contains(other.fileURL)
    }    
    
}

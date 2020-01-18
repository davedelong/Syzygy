//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public protocol HTTPBody {
    var isEmpty: Bool { get }
    var additionalHeaders: Dictionary<String, String> { get }
    func encodeToStream() throws -> InputStream
}

public extension HTTPBody {
    var additionalHeaders: Dictionary<String, String> { return [:] }
}

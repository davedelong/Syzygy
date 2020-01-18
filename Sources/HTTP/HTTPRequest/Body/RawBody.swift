//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct RawBody: HTTPBody {
    
    private let data: Data
    public let isEmpty: Bool
    
    public init(_ data: Data?) {
        self.data = data ?? Data()
        self.isEmpty = self.data.isEmpty
    }
    
    public func encodeToStream() throws -> InputStream {
        return InputStream(data: data)
    }
}

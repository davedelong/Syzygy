//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct JSONBody<E: Encodable>: HTTPBody {
    private let value: E
    private let encoder: JSONEncoder
    
    public let isEmpty = false
    
    public init(_ value: E, encoder: JSONEncoder = JSONEncoder()) {
        self.value = value
        self.encoder = encoder
    }
    
    public func encodeToStream() throws -> InputStream {
        let data = try encoder.encode(value)
        return InputStream(data: data)
    }
    
}

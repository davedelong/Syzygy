//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct FormURLEncoded: HTTPBody {
    
    public  let additionalHeaders = [
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    ]
    
    private let values: Array<URLQueryItem>
    public let isEmpty: Bool
    
    public init(_ values: Array<URLQueryItem>) {
        self.values = values
        self.isEmpty = values.isEmpty
    }
    
    public func encodeToStream() throws -> InputStream {
        let pieces = values.map { $0.formURLEncoded }
        let bodyString = pieces.joined(separator: "&")
        let bodyData = Data(bodyString.utf8)
        return InputStream(data: bodyData)
    }
}

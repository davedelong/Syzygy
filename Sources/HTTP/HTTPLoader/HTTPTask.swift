//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public class HTTPTask {
    
    public var identifier: UUID { request.identifier }
    public let request: HTTPRequest
    internal private(set) var result: HTTPResult?
    
    public init(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        
        self.request = request
        
    }
    
    public func fail(_ code: HTTPError.Code, underlyingError: Error? = nil) {
        let error = HTTPError(code: code, request: request, response: nil, underlyingError: underlyingError)
        complete(with: .failure(error))
    }
    
    public func complete(with result: HTTPResult) {
        
    }
    
}

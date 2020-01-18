//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct HTTPError: Error {
    
    public enum Code {
        case invalidRequest
        case cannotConnect
        case cancelled
        case timedOut
        case cannotAuthenticate
        case insecureConnection
        case invalidResponse
        case cannotDecodeResponse
        case resetInProgress
        case unsupportedVersion
        case unknown
    }
    
    public let code: Code
    public let request: HTTPRequest
    public let response: HTTPResponse?
    public let underlyingError: Error?
    
    public init(code: Code, request: HTTPRequest, response: HTTPResponse? = nil, underlyingError: Error? = nil) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
    
}

extension HTTPError: CustomStringConvertible {
    
    public var description: String {
        let name: String
        switch code {
            case .invalidRequest: name = "Invalid request"
            case .cannotConnect: name = "Cannot connect"
            case .cancelled: name = "Cancelled"
            case .timedOut: name = "Timed out"
            case .cannotAuthenticate: name = "Cannot authenticate"
            case .insecureConnection: name = "Insecure connection"
            case .invalidResponse: name = "Invalid response"
            case .cannotDecodeResponse: name = "Cannot decode response"
            case .resetInProgress: name = "Reset in progress"
            case .unsupportedVersion: name = "Unsupported version"
            case .unknown: name = "Unknown"
        }
        
        var body = "\(name) error when performing \(request)"
        if let response = response {
            body += " (response: \(response))"
        }
        if let underlying = underlyingError {
            body += " (underlying error: \(underlying))"
        }
        return body
    }
    
}

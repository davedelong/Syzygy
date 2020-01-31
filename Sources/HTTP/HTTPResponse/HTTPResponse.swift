//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct HTTPResponse {
    
    public let request: HTTPRequest
    public let response: HTTPURLResponse
    public let body: InputStream
    
    public init(request: HTTPRequest, response: HTTPURLResponse, body: InputStream) {
        self.request = request
        self.response = response
        self.body = body
    }
    
    public init(request: HTTPRequest, response: HTTPURLResponse, body: Data) {
        self.request = request
        self.response = response
        self.body = InputStream(data: body)
    }
    
    public var statusCode: HTTPStatus {
        return HTTPStatus(rawValue: response.statusCode)
    }
    
    public var localizedStatusDescription: String {
        return statusCode.description
    }
    
    // there's a weird problem with directly turning this into a dictionary
    // and that has to do with header case-insensitivity
    public var allHeaderFields: Dictionary<AnyHashable, Any> {
        return response.allHeaderFields
    }
}

extension HTTPResponse: CustomStringConvertible {
    
    public var description: String {
        var lines = Array<String>()
        lines.append("HTTP/1.1 \(statusCode.rawValue) \(localizedStatusDescription)")
        for (header, value) in allHeaderFields {
            lines.append("\(header): \(value)")
        }
        lines.append("")
        
        let bodyData = body.readAll()
        if bodyData.isEmpty == false {
            if let string = String(data: bodyData, encoding: .utf8) {
                lines.append(string)
            } else {
                lines.append(bodyData.base64EncodedString())
            }
        }
        
        return lines.joined(separator: "\n")
    }
    
}

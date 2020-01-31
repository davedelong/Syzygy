//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct HTTPRequest {
    
    public let identifier = UUID()
    
    public var method: HTTPMethod = .get
    private var components = URLComponents()
    public var headers = Dictionary<String, String>()
    public var body: HTTPBody?
    
    public init() {
        scheme = "https"
    }
    
    public var scheme: String? {
        get { return components.scheme }
        set { components.scheme = newValue }
    }
    
    public var host: String? {
        get { return components.host }
        set { components.host = newValue }
    }
    
    public var path: String {
        get { return components.path }
        set { components.path = newValue }
    }
    
    public var url: URL? { components.url }
    
}

extension HTTPRequest {
    
    public mutating func setFormBody(_ formItems: Array<URLQueryItem>) {
        method = .post
        body = FormURLEncoded(formItems)
    }
    
    public var queryItems: Array<URLQueryItem>? {
        get { return components.queryItems }
        set { components.queryItems = newValue }
    }
    
    public mutating func setQueryItem(name: String, value: String?) {
        queryItems = (queryItems ?? []).replacing(name: name, with: value)
        if queryItems?.count == 0 {
            queryItems = nil
        }
    }
    
    public mutating func addQueryItem(name: String, value: String?) {
        var existing = queryItems ?? []
        existing.append(URLQueryItem(name: name, value: value))
        queryItems = existing
    }
    
    public func getQueryItem(name: String) -> URLQueryItem? {
        return queryItems?.first(where: { $0.name == name })
    }
    
}

extension HTTPRequest: CustomStringConvertible {
    
    public var description: String {
        var lines = Array<String>()
        
        var query = ""
        if let qi = queryItems {
            query = "?" + qi.map({ $0.formURLEncoded }).joined(separator: "&")
        }
        
        lines.append("\(method.rawValue) \(path)\(query) HTTP/1.1")
        if let host = host {
            lines.append("Host: \(host)")
        }
        
        for (name, value) in headers {
            lines.append("\(name): \(value)")
        }
        
        if let bodyStream = try? body?.encodeToStream(), body?.isEmpty == false {
            let body = bodyStream.readAll()
            lines.append("")
            if let string = String(data: body, encoding: .utf8) {
                lines.append(string)
            } else {
                lines.append(body.base64EncodedString())
            }
            
        }
        
        lines.append("")
        return lines.joined(separator: "\n")
    }
    
}

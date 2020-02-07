//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import Foundation

public struct Environment: RequestModifier {
    public let host: String
    public let pathPrefix: String
    public let headers: Dictionary<String, String>
    public let query: Array<URLQueryItem>
    
    public init(host: String, pathPrefix: String = "/", headers: Dictionary<String, String> = [:], query: Array<URLQueryItem> = []) {
        // make sure the apiBase starts with a /
        let prefix = pathPrefix.hasPrefix("/") ? "" : "/"
        
        self.host = host
        self.pathPrefix = prefix + pathPrefix
        self.headers = headers
        self.query = query
    }
    
    public func apply(to request: inout HTTPRequest) {
        
        if request.host == nil {
            request.host = host
        }
        
        if request.path.isEmpty {
            request.path = pathPrefix
        } else if request.path.hasPrefix("/") == false {
            request.path = pathPrefix + "/" + request.path
        }
        
        for (header, value) in headers {
            request.headers[header] = value
        }
        
        for queryItem in query {
            request.setQueryItem(name: queryItem.name, value: queryItem.value)
        }
    }
    
    public func modify(request: HTTPRequest) -> RequestModificationResult {
        var copy = request
        apply(to: &copy)
        return .modified(copy)
    }
}

public class ConfiguringLoader: RequestModifyingLoader {
    
    private struct ConfigurationModifier: RequestModifier {
        let environment: Environment
        let perRequestModifier: (inout HTTPRequest) -> Void
        
        func modify(request: HTTPRequest) -> RequestModificationResult {
            var req = request
            
            #warning("TODO: allow a request to specify a custom environment")
            environment.apply(to: &req)
            perRequestModifier(&req)
            return .modified(req)
        }
    }
    
    private let modifier: ConfigurationModifier
    
    public init(environment: Environment, perRequestModifier: @escaping (inout HTTPRequest) -> Void = { _ in }) {
        modifier = ConfigurationModifier(environment: environment, perRequestModifier: perRequestModifier)
        super.init()
    }
    
    public override func retrieveModifier(using loader: HTTPLoader?, completion: @escaping (RequestModifier) -> Void) {
        completion(modifier)
    }
    
}

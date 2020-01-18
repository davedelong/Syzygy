//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public class URLSessionLoader: HTTPLoader {
    
    private var session: URLSession!
    
    public convenience override init() {
        self.init(configuration: .ephemeral)
    }
    
    public init(configuration: URLSessionConfiguration) {
        super.init()
        session = URLSession(configuration: configuration)
    }
    
    public override func load(task: HTTPTask) {
        guard let url = task.request.url else {
            task.fail(.invalidRequest)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = task.request.method.rawValue
        for (header, value) in task.request.headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        if let body = task.request.body, body.isEmpty == false {
            for (header, value) in body.additionalHeaders {
                request.addValue(value, forHTTPHeaderField: header)
            }
            do {
                request.httpBodyStream = try body.encodeToStream()
            } catch let e {
                task.fail(.invalidRequest, underlyingError: e)
                return
            }
        }
        
        let urlTask = session.dataTask(with: request) { (data, response, error) in
            let result = HTTPResult(request: task.request, responseData: data, response: response, error: error)
            task.complete(with: result)
        }
        // TODO: register urlTask with httpTask
        // so if the httpTask is cancelled, the urlTask will be too
        urlTask.resume()
    }
    
    public override func reset(with group: DispatchGroup) {
        group.enter()
        session.reset {
            group.leave()
        }
    }
}

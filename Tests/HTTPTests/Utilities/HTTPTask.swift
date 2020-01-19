//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation
import HTTP

extension HTTPTask {
    
    func succeed(_ code: Int, body: Data? = nil) {
        let urlResponse = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: "1.1", headerFields: nil)!
        let response = HTTPResponse(request: request, response: urlResponse, body: body ?? Data())
        self.succeed(response)
    }
    
    func ok(_ data: Data) {
        self.succeed(200, body: data)
    }
    
    func ok(_ string: String = "") {
        self.succeed(200, body: Data(string.utf8))
    }
    
}

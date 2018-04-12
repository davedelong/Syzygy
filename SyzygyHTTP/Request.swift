//
//  Request.swift
//  SyzygyHTTP
//
//  Created by Dave DeLong on 1/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Request {
    
    public struct Body {
        internal let stream: InputStream
        internal let size: Int?
        internal let headers: Array<Header>
        
        public init(stream: InputStream, length: Int?, headers: Array<Header> = []) {
            self.stream = stream
            self.size = size
            self.headers = headers
        }
        
        public init(data: Data, contentType: UTI = UTI.data) {
            self.init(stream: InputStream(data: data), length: data.count)
        }
        
        public init(form: Never) {
            Die.TODO()
        }
        
        public init(parameters: Never) {
            Die.TODO()
        }
    }
    
    public var method: Method = .get
    public var resource: URLComponents
    public var body: Body?
    
    private var headers = Dictionary<String, String>()
    
    public var expectedResponseType: UTI = .data
    
    public mutating func setHeader(_ header: Header) {
        headers[header.name] = header.value
    }
    
    public mutating func addHeader(_ header: Header) {
        if let existing = headers[header.name] {
            headers[header.name] = existing + "; " + header.value
        } else {
            setHeader(header)
        }
    }
}

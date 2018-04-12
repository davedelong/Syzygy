//
//  HTTPSession.swift
//  SyzygyHTTP
//
//  Created by Dave DeLong on 1/20/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class HTTPSession: NSObject, URLSessionDelegate {
    
    public struct Configuration { }
    
    private let delegateQueue: OperationQueue
    private let urlSession: URLSession
    
    public init(configuration: Configuration) {
        let delegateQueue = OperationQueue()
        
        self.delegateQueue = delegateQueue
        self.urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: delegateQueue)
        super.init()
    }
    
}

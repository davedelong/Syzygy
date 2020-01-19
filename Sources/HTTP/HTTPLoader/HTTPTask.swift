//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public class HTTPTask {
    
    public typealias HTTPHandler = (HTTPResult) -> Void
    
    public var identifier: UUID { request.identifier }
    public let request: HTTPRequest
    internal private(set) var result: HTTPResult?
    
    public private(set) var isCancelled: Bool = false
    private let cancelHandlers = LinkedList<() -> Void>()
    private let completionHandlers: LinkedList<HTTPHandler>
    
    #if DEBUG
    private var completionLocation: Array<String>?
    #endif
    
    public init(request: HTTPRequest, completion: @escaping HTTPHandler) {
        
        self.request = request
        self.completionHandlers = [completion]
        
    }
    
}

extension HTTPTask {
    
    public func addCancelHandler(_ action: @escaping () -> Void) {
        guard isCancelled == false else {
            // already cancelled
            action()
            return
        }
        
        cancelHandlers.insert(action, at: 0)
    }
    
    public func cancel() {
        guard result == nil else { return }
        guard isCancelled == false else { return }
        isCancelled = false
        
        let handlers = Array(cancelHandlers)
        cancelHandlers.removeAll()
        
        handlers.forEach { $0() }
    }
    
}

extension HTTPTask {
    
    public func addCompletionHandler(_ handler: @escaping HTTPHandler) {
        if let r = result {
            DispatchQueue.global().async { handler(r) }
        } else {
            completionHandlers.insert(handler, at: 0)
        }
    }
    
    public func succeed(_ response: HTTPResponse) {
        complete(with: .success(response))
    }
    
    public func fail(_ error: HTTPError) {
        complete(with: .failure(error))
    }
    
    public func fail(_ code: HTTPError.Code, response: HTTPResponse? = nil, underlyingError: Error? = nil) {
        let error = HTTPError(code: code, request: request, response: response, underlyingError: underlyingError)
        complete(with: .failure(error))
    }
    
    public func complete(with result: HTTPResult) {
        let id = request.identifier
        
        guard self.result == nil else {
            #if DEBUG
            fatalError("HTTPTask \(id) has been completed multiple times! Previous completion location occurred from \(self.completionLocation ?? [])")
            #else
            print("HTTPTask \(id) has been completed multiple times!")
            return
            #endif
        }
        
        self.result = result
        
        #if DEBUG
        self.completionLocation = Thread.callStackSymbols
        #endif
        
        let handlers = Array(completionHandlers)
        completionHandlers.removeAll()
        
        DispatchQueue.global().async {
            handlers.forEach { $0(result) }
        }
    }
    
}

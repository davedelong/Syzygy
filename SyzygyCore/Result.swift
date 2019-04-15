//
//  Result.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol ResultType {
    associatedtype SuccessType
    
    var success: SuccessType? { get }
    var error: Error? { get }
    
}

public extension ResultType {
    var isSuccess: Bool { return self.success != nil }
    var isError: Bool { return self.error != nil }
}

public enum Result<T>: ResultType {
    public typealias SuccessType = T
    
    case success(T)
    case error(Error)
    
    public var success: T? {
        if case .success(let s) = self { return s }
        return nil
    }
    
    public var error: Error? {
        if case .error(let e) = self { return e }
        return nil
    }
    
    public func map<U>(_ value: (T) throws -> U, ifError: (Error) -> Error = { $0 }) -> Result<U> {
        switch self {
        case .success(let t):
            do {
                let value = try value(t)
                return .success(value)
            } catch let e {
                return .error(ifError(e))
            }
            
        case .error(let e): return .error(ifError(e))
        }
    }
    
    public init(_ block: () throws -> T) {
        do {
            let value = try block()
            self = .success(value)
        } catch let e {
            self = .error(e)
        }
    }
}

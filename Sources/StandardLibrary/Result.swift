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
    associatedtype FailureType
    
    var success: SuccessType? { get }
    var error: FailureType? { get }
    
}

public extension ResultType {
    var isSuccess: Bool { return self.success != nil }
    var isError: Bool { return self.error != nil }
}

extension Result: ResultType {
    
    public var success: Success? {
        guard case .success(let s) = self else { return nil }
        return s
    }
    
    public var error: Failure? {
        guard case .failure(let f) = self else { return nil }
        return f
    }
    
}

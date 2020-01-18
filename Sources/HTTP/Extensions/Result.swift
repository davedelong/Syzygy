//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

internal extension Result {
    
    var success: Success? {
        switch self {
            case .success(let s): return s
            default: return nil
        }
    }
    
    var failure: Failure? {
        switch self {
            case .failure(let f): return f
            default: return nil
        }
    }
    
    var isSuccess: Bool { return success != nil }
    var isFailure: Bool { return failure != nil }
    
}

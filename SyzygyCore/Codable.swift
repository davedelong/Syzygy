//
//  Codable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/4/20.
//  Copyright © 2020 Syzygy. All rights reserved.
//

import Foundation

fileprivate func prettyPath(_ parts: Array<CodingKey>) -> String {
    let components = parts.enumerated().map { (offset, key) -> String in
        if let idx = key.intValue {
            return "[\(idx)]"
        } else {
            if offset > 0 {
                return ".\(key.stringValue)"
            } else {
                return key.stringValue
            }
        }
    }
    
    return components.joined()
}

extension DecodingError.Context {
    
    public var codingPathDescription: String {
        return prettyPath(codingPath)
    }
}

extension EncodingError.Context {
    
    public var codingPathDescription: String {
        return prettyPath(codingPath)
    }
}

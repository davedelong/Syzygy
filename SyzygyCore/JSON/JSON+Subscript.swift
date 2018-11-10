//
//  JSON+Subscript.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension JSON {
    
    subscript(key: String) -> JSON {
        get {
            if let dict = self.object {
                return dict[key] ?? .unknown
            } else {
                return .unknown
            }
        }
        set {
            if var dict = self.object {
                dict[key] = newValue
                self = .object(dict)
            } else if self.isUnknown {
                self = .object([key: newValue])
            }
            
        }
    }
    
    subscript(index: Int) -> JSON {
        get {
            if let arr = self.array {
                if index >= 0 && index < arr.count {
                    return arr[index]
                }
            }
            return .unknown
        }
        set {
            if var arr = self.array {
                arr[index] = newValue
                self = .array(arr)
            } else if self.isUnknown {
                var pieces = Array(repeating: JSON.unknown, count: max(index - 1, 0))
                pieces.append(newValue)
                self = .array(pieces)
            }
        }
    }
}

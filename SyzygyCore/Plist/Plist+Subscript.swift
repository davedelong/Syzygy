//
//  Plist+Subscript.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Plist {
    
    subscript(key: String) -> Plist {
        get {
            if let dict = self.dictionary {
                return dict[key] ?? .unknown
            } else {
                return .unknown
            }
        }
        set {
            if var dict = self.dictionary {
                dict[key] = newValue
                self = .dictionary(dict)
            }
            
        }
    }
    
    subscript(index: Int) -> Plist {
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
            }
        }
    }
}

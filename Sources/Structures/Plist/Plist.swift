//
//  Plist.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public enum Plist {
    case unknown
    
    case string(String)
    case date(Date)
    case data(Data)
    case integer(Int)
    case number(Double)
    case boolean(Bool)
    
    case array(Array<Plist>)
    case dictionary(Dictionary<String, Plist>)
    
    public enum Format {
        case xml
        case binary
        case openStep
    }
    
    public struct Error: Swift.Error {
        public let message: String
        public init(_ message: String) {
            self.message = message
        }
    }
    
}

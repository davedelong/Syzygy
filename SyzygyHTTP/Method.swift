//
//  Method.swift
//  SyzygyHTTP
//
//  Created by Dave DeLong on 2/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Method: Newtype {
    public static let get = Method(rawValue: "GET")
    public static let post = Method(rawValue: "POST")
    public static let put = Method(rawValue: "PUT")
    public static let head = Method(rawValue: "HEAD")
    public static let delete = Method(rawValue: "DELETE")
    public static let options = Method(rawValue: "OPTIONS")
    public static let patch = Method(rawValue: "PATCH")
    
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue.uppercased() }
}

//
//  BasicEvent.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

import Foundation

public struct BasicEvent: AnalyticEvent {
    public let name: String
    public let metadata: Dictionary<String, String>
    
    public let file: StaticString
    public let line: UInt
    public let time: Date
    
    public init(name: String, metadata: Dictionary<String, String> = [:], file: StaticString = #file, line: UInt = #line, time: Date = Date()) {
        self.name = name
        self.metadata = metadata
        self.file = file
        self.line = line
        self.time = time
    }
}

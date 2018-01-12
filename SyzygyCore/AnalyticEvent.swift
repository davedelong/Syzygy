//
//  AnalyticEvent.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

import Foundation

public protocol AnalyticEvent {
    var name: String { get }
    var metadata: Dictionary<String, String> { get }
    
    var file: StaticString { get }
    var line: UInt { get }
    var time: Date { get }
}

public extension AnalyticEvent {
    var metadata: Dictionary<String, String> { return [:] }
}

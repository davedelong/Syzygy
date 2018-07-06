//
//  Analytics.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

import Foundation

public final class Analytics {
    
    private static let _engineLock = NSLock()
    private static var _engine: AnalyticEngine = LoggingAnalyticEngine()
    
    public static var engine: AnalyticEngine {
        get {
            _engineLock.lock()
            let e = _engine
            _engineLock.unlock()
            return e
        }
        
        set {
            _engineLock.lock()
            _engine = newValue
            _engineLock.unlock()
        }
    }
    
    public static func record(event: AnalyticEvent) { engine.record(event: event) }
    public static func record(name: String, metadata: Dictionary<String, String> = [:], file: StaticString = #file, line: UInt = #line, time: Date = Date()) {
        let event = BasicEvent(name: name, metadata: metadata, file: file, line: line, time: time)
        engine.record(event: event)
    }
    
    private init() { }
    
}

//
//  AnalyticEngine.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

import Foundation

public protocol AnalyticEngine {
    
    func record(event: AnalyticEvent)
    
}

public struct LoggingAnalyticEngine: AnalyticEngine {
    
    private let loggingQueue = DispatchQueue(specificLabel: "LoggingAnalyticEngine")
    
    public func record(event: AnalyticEvent) {
        
        let now = Date()
        let queueName = DispatchQueue.getLabel()
        
        loggingQueue.async {
            var message = "ANALYTIC EVENT \(event.name)"
            if event.metadata.isEmpty == false {
                let keys = event.metadata.keys.sorted()
                let lines = keys.map { "\t\($0): \(event.metadata[$0]!)" }.joined(separator: "\n")
                message.append(lines)
            }
            
            Log.log(severity: LogSeverity.debug, file: event.file, line: event.line, queueName: queueName, date: now, message: message, arguments: [])
        }
    }
    
}

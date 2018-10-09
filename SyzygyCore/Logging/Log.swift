//
//  Log.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import os.log

public var Log: LoggingService = DefaultLog.shared

private let ContextKey = DispatchSpecificKey<Array<String>>()

public enum LogSeverity: String {
    case `default`
    case debug
    case info
    case error
    case fault
}

public protocol LoggingService {
    
    func log(severity: LogSeverity, file: StaticString, line: UInt, queueName: String, date: Date, message: String, arguments: Array<CVarArg>)
    func retrieveLogPath(_ completion: @escaping (AbsolutePath) -> Void)
    
    func pushScope(_ scope: String, file: StaticString, line: UInt, sentinel: Bool)
    func popScope(file: StaticString, line: UInt, sentinel: Bool)
    func withScope<T>(_ scope: String, file: StaticString, line: UInt, sentinel: Bool, execute: @escaping () throws -> T) rethrows -> T
}

public extension LoggingService {
    
    func message(file: StaticString = #file, line: UInt = #line, _ message: String, _ args: CVarArg...) {
        log(severity: .default, file: file, line: line, queueName: DispatchQueue.getLabel(), date: Date(), message: message, arguments: args)
    }
    
    func debug(file: StaticString = #file, line: UInt = #line, _ message: String, _ args: CVarArg...) {
        log(severity: .debug, file: file, line: line, queueName: DispatchQueue.getLabel(), date: Date(), message: message, arguments: args)
    }
    
    func info(file: StaticString = #file, line: UInt = #line, _ message: String, _ args: CVarArg...) {
        log(severity: .info, file: file, line: line, queueName: DispatchQueue.getLabel(), date: Date(), message: message, arguments: args)
    }
    
    func error(file: StaticString = #file, line: UInt = #line, _ message: String, _ args: CVarArg...) {
        log(severity: .error, file: file, line: line, queueName: DispatchQueue.getLabel(), date: Date(), message: message, arguments: args)
    }
    
    func fault(file: StaticString = #file, line: UInt = #line, _ message: String, _ args: CVarArg...) {
        log(severity: .fault, file: file, line: line, queueName: DispatchQueue.getLabel(), date: Date(), message: message, arguments: args)
    }
    
    func pushScope(_ scope: String, file: StaticString = #file, line: UInt = #line) {
        pushScope(scope, file: file, line: line, sentinel: true)
    }
    
    func popScope(file: StaticString = #file, line: UInt = #line) {
        popScope(file: file, line: line, sentinel: true)
    }
    
    func withScope<T>(_ scope: String, file: StaticString = #file, line: UInt = #line, execute: @escaping () throws -> T) rethrows -> T {
        return try withScope(scope, file: file, line: line, sentinel: true, execute: execute)
    }
    
}

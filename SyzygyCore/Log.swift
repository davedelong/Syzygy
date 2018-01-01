//
//  Log.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import os.log

public var Log: LogType = DefaultLog.shared

public enum LogSeverity: String {
    case `default`
    case debug
    case info
    case error
    case fault
}

public protocol LogType {
    
    func log(severity: LogSeverity, file: StaticString, line: UInt, queueName: String, date: Date, message: String, arguments: Array<CVarArg>)
    func retrieveLogPath(_ completion: @escaping (AbsolutePath) -> Void)
    
}

public extension LogType {
    
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
    
}

public final class DefaultLog: LogType {
    public static let shared = DefaultLog()
    
    private let q = DispatchQueue(specificLabel: "Log")
    private let file: AbsolutePath
    private var handles: Array<FileHandle>
    
    public init(location: AbsolutePath? = nil) {
        let logFile: AbsolutePath
        
        if let location = location {
            logFile = location
        } else {
            let folder = Sandbox.currentProcess.support
            let name = "\(Bundle.main.name).log"
            logFile = folder.appending(component: name)
        }
        
        if FileManager.default.fileExists(atPath: logFile) {
            let movedAside = logFile.appending(lastItemPiece: "-previous")
            try? FileManager.default.removeItem(atPath: movedAside)
            try? FileManager.default.moveItem(atPath: logFile, toPath: movedAside)
        }
        
        FileManager.default.createFile(atPath: logFile)
        
        file = logFile
        handles = [FileHandle(forWritingAtPath: logFile) !! "Unable to create log file"]
        #if DEBUG
            handles.append(FileHandle.standardError)
        #endif
    }
    
    public func log(severity: LogSeverity, file: StaticString = #file, line: UInt = #line, queueName: String = DispatchQueue.getLabel(), date: Date = Date(), message: String, arguments: Array<CVarArg> = []) {
        let name = severity.rawValue
        let fileName = AbsolutePath(fileSystemPath: file).lastItem ?? "Unknown"
        let fileAndLine = fileName + ":" + String(line)
        
        let formattedMessage = String(format: message, arguments: arguments)
        let line = "[\(name)]\t[\(queueName)]\t[\(fileAndLine)]\t\(date):\t\(formattedMessage)\n"
        q.async {
            if let data = line.data(using: .utf8) {
                do {
                    try catchException {
                        self.handles.forEach {
                            $0.write(data)
                        }
                    }
                } catch let e {
                    NSLog("Error writing to log handles: \(e)")
                }
            }
        }
    }
    
    public func retrieveLogPath(_ completion: @escaping (AbsolutePath) -> Void) {
        q.async {
            completion(self.file)
        }
    }
    
}

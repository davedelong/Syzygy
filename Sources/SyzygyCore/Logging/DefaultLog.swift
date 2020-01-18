//
//  DefaultLog.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 10/8/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import Core

public final class DefaultLog: LoggingService {
    public static let shared = DefaultLog()
    
    private let q = DispatchQueue(specificLabel: "Log")
    private let file: AbsolutePath
    private var handles: Array<FileHandle>
    
    private let scopeLock = NSRecursiveLock()
    private var scopes = Dictionary<String, Array<String>>()
    
    public init(location: AbsolutePath? = nil) {
        let logFile: AbsolutePath
        
        if let location = location {
            logFile = location
        } else {
            let folder = Sandbox.currentProcess.logs
            let name = "\(Bundle.main.name).log"
            logFile = folder.appending(component: name)
        }
        
        if FileManager.default.fileExists(atPath: logFile) {
            let movedAside = logFile.appending(lastItemPiece: "-previous")
            try? FileManager.default.removeItem(atPath: movedAside)
            try? FileManager.default.moveItem(atPath: logFile, toPath: movedAside)
        }
        
        FileManager.default.createFile(atPath: logFile)
        
        #if DEBUG
        print("Writing to log file at \(logFile.fileSystemPath)")
        #endif
        
        file = logFile
        handles = [FileHandle(forWritingAtPath: logFile) !! "Unable to create log file"]
        #if DEBUG
        handles.append(FileHandle.standardError)
        #endif
        
        let pieces = [
            "Severity",
            "Scope",
            "Queue",
            "Location",
            "Time",
            "Message"
        ]
        _log(pieces)
    }
    
    public func pushScope(_ scope: String, file: StaticString, line: UInt, sentinel: Bool) {
        scopeLock.lock()
        let key = DispatchQueue.getLabel()
        var current = scopes.removeValue(forKey: key) ?? []
        current.append(scope)
        scopes[key] = current
        
        log(severity: .info, file: file, line: line, message: "Entering scope: %@", arguments: [scope])
        scopeLock.unlock()
    }
    
    public func popScope(file: StaticString, line: UInt, sentinel: Bool) {
        scopeLock.lock()
        let key = DispatchQueue.getLabel()
        var current = scopes.removeValue(forKey: key) ?? []
        let scope = current.popLast()
        scopes[key] = current
        if let s = scope {
            log(severity: .info, file: file, line: line, message: "Exited scope: %@", arguments: [s])
        } else {
            log(severity: .error, file: file, line: line, message: "Attempted to exit an empty scope")
        }
        scopeLock.unlock()
    }
    
    public func withScope<T>(_ scope: String, file: StaticString, line: UInt, sentinel: Bool, execute: @escaping () throws -> T) rethrows -> T {
        scopeLock.lock()
        pushScope(scope, file: file, line: line)
        let returnValue = try execute()
        popScope(file: file, line: line)
        scopeLock.unlock()
        return returnValue
    }
    
    private func currentScope(for queue: String) -> String {
        scopeLock.lock()
        let scopes = self.scopes[queue] ?? []
        scopeLock.unlock()
        return scopes.joined(separator: " → ")
    }
    
    public func log(severity: LogSeverity, file: StaticString = #file, line: UInt = #line, queueName: String = DispatchQueue.getLabel(), date: Date = Date(), message: String, arguments: Array<CVarArg> = []) {
        
        let pieces = [
            severity.rawValue,
            currentScope(for: queueName),
            queueName,
            AbsolutePath(fileSystemPath: file).format(with: line),
            date.description,
            String(format: message, arguments: arguments)
        ]
        
        _log(pieces)
    }
    
    private func _log(_ pieces: Array<String>) {
        q.async {
            let line = pieces.joined(separator: "\t") + "\n"
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

private extension AbsolutePath {
    
    func format(with line: UInt) -> String {
        let name = self.lastItem ?? "unknown"
        return "\(name):\(line)"
    }
    
}

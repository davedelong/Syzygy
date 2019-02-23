//
//  Process.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Process {
    
    public struct ProcessError: Error {
        public let exitCode: Int32
        public let reason: Process.TerminationReason
    }
    
    public struct ApplescriptError: Error {
        public let errorDictionary: NSDictionary
    }
    
    public class func runSynchronously(_ path: AbsolutePath, arguments: Array<String> = [], usingPipe: Bool = false) -> Result<Data> {
        return runAsUser(path, arguments: arguments, usingPipe: usingPipe)
    }
    
    public class func run(process path: AbsolutePath, arguments: Array<String> = [], asAdministrator: Bool = false, usingPipe: Bool = false, completion: @escaping (Result<Data>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result: Result<Data>
            
            if asAdministrator == true {
                result = runAsAdmin(path, arguments: arguments)
            } else {
                result = runAsUser(path, arguments: arguments, usingPipe: usingPipe)
            }
            
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    private class func runAsAdmin(_ path: AbsolutePath, arguments: Array<String>) -> Result<Data> {
        let allArguments = arguments.map { "'\($0)'" }.joined(separator: " ")
        let fullScript = "\(path.fileSystemPath) \(allArguments)"
        
        // may God have mercy on my soul
        let applescriptSource = "do shell script \"\(fullScript)\" with administrator privileges"
        let applescript = NSAppleScript(source: applescriptSource)
        
        var errorInfo: NSDictionary?
        if let eventResult = applescript?.executeAndReturnError(&errorInfo) {
            let string = eventResult.stringValue ?? ""
            return .success(Data(string.utf8))
        } else {
            let error = ApplescriptError(errorDictionary: errorInfo ?? [:])
            return .error(error)
        }
    }
    
    private class func runAsUser(_ path: AbsolutePath, arguments: Array<String>, usingPipe: Bool = false) -> Result<Data> {
        let task = Process()
        task.launchPath = path.fileSystemPath
        task.arguments = arguments
        task.qualityOfService = .userInitiated
        
        let outputHandle: FileHandle?
        if usingPipe == false {
            let output = TemporaryFile(extension: "txt")
            outputHandle = output.fileHandle
            task.standardOutput = outputHandle
            defer { outputHandle?.closeFile() }
        } else {
            let pipe = Pipe()
            task.standardOutput = pipe
            outputHandle = pipe.fileHandleForReading
        }
        
        task.launch()
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            let error = ProcessError(exitCode: task.terminationStatus, reason: task.terminationReason)
            return .error(error)
        } else {
            do {
                let result = try catchException { () -> Result<Data> in
                    outputHandle?.seek(toFileOffset: 0)
                    let data = outputHandle?.readDataToEndOfFile()
                    
                    return .success(data ?? Data())
                }
                return result
            } catch {
                Log.info("Attempting to read process output threw an exception: \(error)")
                let error = ProcessError(exitCode: EPERM, reason: .uncaughtSignal)
                return .error(error)
            }
        }
    }
}

//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/21/20.
//

import Foundation

internal extension InputStream {
    
    func readAll() -> Data {
        return StreamReader(stream: self).readAll()
    }
    
}

fileprivate class StreamReader: NSObject, StreamDelegate {
    
    private var inputStream: InputStream
    private var keepGoing = true
    private let data = NSMutableData()
    
    init(stream: InputStream) {
        self.inputStream = stream
        super.init()
    }
    
    fileprivate func readAll() -> Data {
        inputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .default)
        inputStream.open()
        while keepGoing {
            RunLoop.current.run(mode: .default, before: .distantFuture)
        }
        inputStream.close()
        inputStream.remove(from: .current, forMode: .default)
        return data as Data
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        var isDone = false
        
        if eventCode.contains(.hasBytesAvailable) {
            var local = Array<UInt8>(repeating: 0, count: 1024)
            let bytesRead = inputStream.read(&local, maxLength: 1024)
            data.append(&local, length: bytesRead)
            if bytesRead == 0 { isDone = true }
        }
        
        if eventCode.contains(.errorOccurred) || eventCode.contains(.endEncountered) {
            isDone = true
        }
        
        keepGoing = !isDone
    }
    
}

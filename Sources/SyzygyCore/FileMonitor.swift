//
//  FileMonitor.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public final class FileMonitor {
    private var path: AbsolutePath
    private let events: DispatchSource.FileSystemEvent
    private var source: DispatchSourceFileSystemObject?
    
    public var handler: ((DispatchSource.FileSystemEvent) -> AbsolutePath?)?
    
    public init(path: AbsolutePath, events: DispatchSource.FileSystemEvent = .all) {
        self.path = path
        self.events = events
        resetSource()
    }
    
    deinit {
        if let source = source {
            source.cancel()
            self.source = nil
        }
    }
    
    private func resetSource() {
        if let source = self.source {
            source.cancel()
            self.source = nil
        }
        
        let queue = DispatchQueue.main
        let f = open(path.fileSystemPath, O_EVTONLY | O_SYMLINK)
        
        if f > 0 {
            setupVNodeMonitor(f, queue: queue)
        } else {
            setupTimer(queue)
        }
    }
    
    private func setupTimer(_ queue: DispatchQueue) {
        // we were unable to open the file for monitoring
        // try again soon
        queue.async(after: 0.5, block: { [weak self] in self?.resetSource() })
    }
    
    private func setupVNodeMonitor(_ file: Int32, queue: DispatchQueue) {
        let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: file, eventMask: events, queue: queue)
        
        source.setEventHandler(handler: { [weak self] in
            self?.eventHandler()
        })
        source.setCancelHandler(handler: {
            close(file)
        })
        self.source = source
        
        source.resume()
    }
    
    private func eventHandler() {
        guard let source = source else { return }
        guard let handler = handler else { return }
        
        let flags = source.data
        let newPath = handler(flags)
        
        var needsResetting = flags.contains(.delete)
        
        if let newPath = newPath {
            path = newPath
            needsResetting = true
        }
        
        if needsResetting == true {
            resetSource()
        }
    }
}

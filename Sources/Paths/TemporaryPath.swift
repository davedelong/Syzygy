//
//  TemporaryPath.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public final class TemporaryFile {
    
    public let location: AbsolutePath
    
    public lazy var fileHandle: FileHandle? = {
        return FileHandle(forUpdatingAtPath: self.location.fileSystemPath)
    }()
    
    public init(extension ext: String? = nil, in directory: AbsolutePath = .temporaryDirectory, contents: Data? = nil) {
        var name = UUID().uuidString
        if let ext = ext {
            name = name + "." + ext
        }
        location = AbsolutePath.temporaryDirectory.appending(component: name)
        
        FileManager.default.createFile(atPath: location.fileSystemPath, contents: contents)
    }
    
    deinit {
        let path = self.location
        DispatchQueue.global(qos: .utility).async {
            try? FileManager.default.removeItem(atPath: path.fileSystemPath)
        }
    }
}


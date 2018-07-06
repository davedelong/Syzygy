//
//  TemporaryPath.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol ManagedPath {
    var content: AbsolutePath { get }
    func keepAlive()
}

public extension ManagedPath {
    public func keepAlive() { }
}

extension AbsolutePath: ManagedPath {
    public var content: AbsolutePath { return self }
}

public final class TemporaryPath: ManagedPath {
    
    public let content: AbsolutePath
    
    public lazy var fileHandle: FileHandle? = {
        return FileHandle(forUpdatingAtPath: self.content)
    }()
    
    public init(extension ext: String? = nil, in directory: AbsolutePath = .temporaryDirectory) {
        var name = UUID().uuidString
        if let ext = ext {
            name = name + "." + ext
        }
        content = AbsolutePath.temporaryDirectory.appending(component: name)
        
        FileManager.default.createFile(atPath: content)
    }
    
    deinit {
        let path = self.content
        DispatchQueue.global(qos: .utility).async {
            try? FileManager.default.removeItem(atPath: path)
        }
    }
}


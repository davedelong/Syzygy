//
//  URL+Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension URL {
    
    var absolutePath: AbsolutePath { return AbsolutePath(fileSystemPath: self.path) }
    
}

public extension URLComponents {
    
    var absolutePath: AbsolutePath {
        
        get {
            return AbsolutePath(fileSystemPath: self.path)
        }
        set {
            self.path = newValue.fileSystemPath
        }
        
    }
    
}

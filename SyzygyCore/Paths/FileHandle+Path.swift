//
//  FileHandle+Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension FileHandle {
    
    convenience init?(forReadingAtPath path: AbsolutePath) {
        self.init(forReadingAtPath: path.fileSystemPath)
    }
    
    convenience init?(forWritingAtPath path: AbsolutePath) {
        self.init(forWritingAtPath: path.fileSystemPath)
    }
    
    convenience init?(forUpdatingAtPath path: AbsolutePath) {
        self.init(forUpdatingAtPath: path.fileSystemPath)
    }
    
}

//
//  Cloning.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension NSCoding {
    
    func clone() -> Self {
        let d = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: d) as! Self
        
    }
    
}

//
//  NSSortDescriptor.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation


extension NSSortDescriptor: Sorting {
    
    public func orders(_ a: Any, before b: Any) -> Bool {
        return compare(a, to: b) == .orderedAscending
    }
    
}

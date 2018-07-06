//
//  IndexPath~macos.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension IndexPath {
    
    public var row: Int {
        get { return self.item }
        set { self.item = newValue }
    }
    
    public init(row: Int, section: Int) {
        self.init(item: row, section: section)
    }
    
}

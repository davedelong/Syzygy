//
//  IndexPath~macos.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension IndexPath {
    
    var row: Int {
        get { return self.item }
        set { self.item = newValue }
    }
    
    init(row: Int, section: Int) {
        self.init(item: row, section: section)
    }
    
}

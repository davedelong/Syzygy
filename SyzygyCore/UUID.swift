//
//  UUID.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 9/28/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension UUID {
    
    init?(_ cfuuid: CFUUID) {
        guard let cfstring = CFUUIDCreateString(nil, cfuuid) else { return nil }
        let string = cfstring as String
        self.init(uuidString: string)
    }
    
    init?(_ nsuuid: NSUUID) {
        self.init(uuidString: nsuuid.uuidString)
    }
    
}

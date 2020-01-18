//
//  DateInterval.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension DateInterval {
    
    var mid: Date {
        let diff = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        let half = diff / 2.0
        return start.addingTimeInterval(half)
    }
    
}

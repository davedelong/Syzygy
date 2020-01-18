//
//  Property+From.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

public extension Property {
    
    static func from<S: Sequence>(_ sequence: S, every interval: TimeInterval) throws -> Property<T> where S.Iterator.Element == T {
        var iterator = sequence.makeIterator()
        guard let first = iterator.next() else {
            throw PropertyError.missingInitialValue
        }
        
        let m = MutableProperty(first)
        
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now() + interval, repeating: interval)
        
        let stopTimer = ActionDisposable {
            timer.cancel()
            timer.setEventHandler(handler: nil)
        }
        
        timer.setEventHandler { [weak m, weak stopTimer] in
            if let next = iterator.next(), let m = m {
                m.value = next
            } else {
                stopTimer?.dispose()
            }
        }
        
        timer.resume()
        
        m.addCleanupDisposable(stopTimer)
        
        return m
    }
    
}

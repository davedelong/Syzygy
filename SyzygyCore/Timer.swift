//
//  Timer.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public class Timer {
    private var source: DispatchSourceTimer?
    private let handler: (Timer) -> Void
    
    public init(interval: TimeInterval, repeats: Bool = true, queue: DispatchQueue = .main, handler: @escaping (Timer) -> Void) {
        let source = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        self.handler = handler
        self.source = source
        
        let intervalInNSec = Int(interval * Double(NSEC_PER_SEC))
        let startTime = DispatchTime.now() + interval
        let leeway = intervalInNSec / 10
        
        let repeating: DispatchTimeInterval = repeats ? .nanoseconds(intervalInNSec) : .never
        source.scheduleRepeating(deadline: startTime, interval: repeating, leeway: .nanoseconds(leeway))
        source.setEventHandler(handler: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.handler(strongSelf)
        })
        source.resume()
    }
    
    deinit {
        invalidate()
    }
    
    public func invalidate() {
        if let source = source {
            source.cancel()
            self.source = nil
        }
    }
    
}

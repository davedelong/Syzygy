//
//  Property+Throttle.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    func throttle(_ interval: TimeInterval, on queue: DispatchQueue = .main) -> Property<T> {
        let m = MutableProperty(value)
        
        let state = ThrottleState(m, interval: interval, queue: queue)
        
        observeNext { value in
            state.pushValue(value)
        }
        
        return m
    }
}

private class ThrottleState<T> {
    let property: MutableProperty<T>
    let interval: TimeInterval
    let queue: DispatchQueue
    var pendingValues = Array<T>()
    var lastSendDate = Date()
    
    private let lock = NSLock()
    private var nextEvent: DispatchWorkItem?
    
    init(_ p: MutableProperty<T>, interval i: TimeInterval, queue q: DispatchQueue) {
        property = p
        interval = i
        queue = q
    }
    
    deinit {
        lock.lock()
        nextEvent?.cancel()
        lock.unlock()
    }
    
    func pushValue(_ value: T) {
        lock.lock()
        pendingValues.append(value)
        scheduleNextEvent()
        lock.unlock()
    }
    
    func popValue() {
        lock.lock()
        nextEvent = nil
        
        if let next = pendingValues.first {
            pendingValues.removeFirst()
            property.value = next
            scheduleNextEvent()
        }
        lock.unlock()
    }
    
    func scheduleNextEvent() {
        // THIS MUST BE WITHIN THE LOCK
        if nextEvent == nil && pendingValues.isEmpty == false {
            let next = DispatchWorkItem { [weak self] in
                self?.popValue()
            }
            
            let nextScheduledTime = lastSendDate.addingTimeInterval(interval)
            let intervalToNextTime = max(nextScheduledTime.timeIntervalSinceNow, 0)
            
            queue.asyncAfter(deadline: .now() + intervalToNextTime, execute: next)
            
            lastSendDate = Date(timeIntervalSinceNow: intervalToNextTime)
            nextEvent = next
        }
    }
}

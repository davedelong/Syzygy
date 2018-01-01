//
//  Dispatch.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

private let LabelKey = DispatchSpecificKey<String>()

public extension DispatchQueue {
    
    public class func getLabel() -> String {
        _ = DispatchQueue.setup
        return getSpecific(key: LabelKey) ?? "UNK"
    }
    
    public convenience init(specificLabel: String, target: DispatchQueue? = nil) {
        self.init(label: specificLabel, target: target)
        setSpecific(key: LabelKey, value: specificLabel)
    }
    
    /// Execute a block a certain number of times on the dispatch queue.
    public func apply(_ count: Int, block: (Int) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count, execute: block)
    }
    
    /// Perform a block after a specified time interval has elapsed.
    ///
    /// - parameter interval: The number of seconds to wait before executing `block`.
    /// - parameter block: The block to execute.
    public func async(after interval: TimeInterval, block: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + interval, execute: block)
    }
    
    public func async(at time: Date, execute: @escaping () -> Void) {
        let interval = max(time.timeIntervalSinceNow, 0)
        asyncAfter(deadline: .now() + interval, execute: execute)
    }
    
    public func async(at time: Date, execute: DispatchWorkItem) {
        let interval = max(time.timeIntervalSinceNow, 0)
        asyncAfter(deadline: .now() + interval, execute: execute)
    }
}

fileprivate extension DispatchQueue {
    
    static let setup: Void = {
        let queues = [
            ".main": DispatchQueue.main,
            ".background": DispatchQueue.global(qos: .background),
            ".utility": DispatchQueue.global(qos: .utility),
            ".default": DispatchQueue.global(qos: .default),
            ".userInitiated": DispatchQueue.global(qos: .userInitiated),
            ".userInteractive": DispatchQueue.global(qos: .userInteractive),
            ".unspecified": DispatchQueue.global(qos: .unspecified)
        ]
        for (name, q) in queues {
            q.setSpecific(key: LabelKey, value: name)
        }
    }()
    
}

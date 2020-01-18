//
//  Property+Timer.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

public extension Property {
    
    convenience init(pollEvery interval: TimeInterval, on queue: DispatchQueue = .main, producing: @escaping () -> T) {
        let initial = producing()
        self.init(initial)
        
        let t = Timer(interval: interval, repeats: true, queue: queue, handler: { [weak self] _ in
            self?.setValue(producing())
        })
        
        addCleanupDisposable(ActionDisposable { t.invalidate() })
    }
    
}

public extension Property where T == Date {
    
    convenience init(pollEvery interval: TimeInterval, on queue: DispatchQueue = .main) {
        self.init(pollEvery: interval, on: queue, producing: { Date() })
    }
    
}

//
//  NSMetadataQuery+Property.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

public extension NSMetadataQuery {
    
    func property() -> Property<Array<NSMetadataItem>> {
        let m = MutableProperty<Array<NSMetadataItem>>([])
        let token = NotificationCenter.default.addObserver(forName: nil, object: self, queue: .main, using: { note in
            guard let q = note.object as? NSMetadataQuery else { return }
            /*
             There is a very good reason for not using "q.results" here.
             q.results returns an NSArray subclass that overrides -retain and -release
             That causes some weird behaviors with Swift-ARC, which manifests as
             a crash trying to deallocate and already-deallocated array.
             
             So instead, we'll just manually build our own regular array.
             */
            var results = Array<NSMetadataItem>()
            q.enumerateResults({ (item, index, stop) in
                guard let item = item as? NSMetadataItem else { return }
                results.append(item)
            })
            m.value = results
        })
        m.addCleanupDisposable(ActionDisposable {
            NotificationCenter.default.removeObserver(token)
            self.stop()
        })
        
        if isStarted == false { start() }
        return m
    }
    
}

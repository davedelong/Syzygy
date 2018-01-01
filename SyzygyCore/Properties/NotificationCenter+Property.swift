//
//  NotificationCenter+Property.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    
    public func property(for notification: Notification.Name?, from sender: Any?) -> Property<Notification?> {
        let m = MutableProperty<Notification?>(nil)
        
        let token = addObserver(forName: notification, object: sender, queue: .main, using: { [weak m] note in
            m?.value = note
        })
        
        // when the property goes away, remove the observation
        // we technically should do the same thing for the notification center,
        // but in practice, NotificationCenters are singletons and live forever
        m.addCleanupDisposable(ActionDisposable { self.removeObserver(token) })
        
        return m
    }
    
}

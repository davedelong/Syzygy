//
//  KeyValueStore.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 11/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol KeyValueStore {
    func retrieveValue(for key: String) -> Any?
    func persistValue(_ value: Any?, for key: String)
}

extension UserDefaults: KeyValueStore {
    
    public func retrieveValue(for key: String) -> Any? {
        return self.object(forKey: key)
    }
    
    public func persistValue(_ value: Any?, for key: String) {
        if let v = value {
            self.set(v, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
    }
    
}

extension NSUbiquitousKeyValueStore: KeyValueStore {
    
    public func retrieveValue(for key: String) -> Any? {
        return self.object(forKey: key)
    }
    
    public func persistValue(_ value: Any?, for key: String) {
        self.set(value, forKey: key)
    }
    
}

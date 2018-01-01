//
//  Property+UserDefaults.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension MutableProperty {
    
    public convenience init(userDefaults: UserDefaults, key: String, defaultValue: T) {
        self.init(userDefaults: userDefaults, key: key, read: { ($0 as? T) ?? defaultValue }, write: { $0 })
    }
    
    public convenience init(userDefaults: UserDefaults, key: String, read: @escaping (Any?) -> T, write: @escaping (T) -> Any?) {
        
        let value = read(userDefaults.object(forKey: key))
        self.init(value)
        
        let d = observeNext { newValue in
            userDefaults.set(write(newValue), forKey: key)
        }
        addCleanupDisposable(d)
    }

}

public extension MutableProperty where T == Array<UTI> {
    
    public convenience init(userDefaults: UserDefaults, key: String, defaultValue: T) {
        self.init(userDefaults: userDefaults, key: key, read: { value in
            guard let array = value as? Array<String> else { return defaultValue }
            return array.map { UTI($0) }
        }, write: { newValue -> Any? in
            return newValue.map { $0.rawValue }
        })
    }
    
}

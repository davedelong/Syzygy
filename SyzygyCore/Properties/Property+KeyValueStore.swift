//
//  Property+KeyValueStore.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension MutableProperty {
    
    public convenience init(store: KeyValueStore, key: String, defaultValue: T) {
        self.init(store: store, key: key, read: { ($0 as? T) ?? defaultValue }, write: { $0 })
    }
    
    public convenience init(store: KeyValueStore, key: String, read: @escaping (Any?) -> T, write: @escaping (T) -> Any?) {
        let value = read(store.retrieveValue(for: key))
        self.init(value)
        
        let d = observeNext { newValue in
            store.persistValue(write(newValue), for: key)
        }
        addCleanupDisposable(d)
    }

}

public extension MutableProperty where T == Array<UTI> {
    
    public convenience init(store: KeyValueStore, key: String, defaultValue: T) {
        self.init(store: store, key: key, read: { value in
            guard let array = value as? Array<String> else { return defaultValue }
            return array.map { UTI(rawValue: $0) }
        }, write: { newValue -> Any? in
            return newValue.map { $0.rawValue }
        })
    }
    
}

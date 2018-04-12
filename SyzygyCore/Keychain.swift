//
//  Keychain.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/30/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import Security

public class Keychain {
    private let name: String
    private let accessGroup: String?
    
    public init(name: String, accessGroup: String? = nil) {
        self.name = name
        self.accessGroup = accessGroup
    }
    
    /// Get and set values into the Keychain.
    public subscript<T: NSSecureCoding>(key: String) -> T? {
        get { return fetch(key) }
        set { save(newValue, forKey: key) }
    }
    
    public subscript<T: ReferenceConvertible>(key: String) -> T? where T.ReferenceType: NSSecureCoding {
        get {
            let referenceValue: T.ReferenceType? = fetch(key)
            return referenceValue as? T
        }
        set {
            save(newValue as? T.ReferenceType, forKey: key)
        }
    }
    
    /// Retrieve all the keys used to store data in the Keychain.
    public func allKeys() -> Array<String> {
        var query = queryForKey(nil)
        query[kSecReturnAttributes as String] = true
        
        var values: AnyObject?
        let status = withUnsafeMutablePointer(to: &values) {
            return SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status == errSecSuccess else { return [] }
        guard let attributes = values as? Array<Dictionary<String, AnyObject>> else { return [] }
        
        let keys = attributes.reduce(Array<String>()) { (soFar, element) in
            guard let key = element[kSecAttrAccount as String] as? String else { return soFar }
            var aggregate = soFar
            aggregate.append(key)
            return aggregate
        }
        
        return keys
    }
    
    /// Retrieve a value from the Keychain, if it exists.
    internal func fetch<T: NSSecureCoding>(_ key: String) -> T? {
        var query = queryForKey(key)
        query[kSecReturnData as String] = true
        
        var value: AnyObject?
        let status = withUnsafeMutablePointer(to: &value) {
            return SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status == errSecSuccess else { return nil }
        guard let data = value as? Data else { return nil }
        guard data.isEmpty == false else { return nil }
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) else { return nil }
        
        return object as? T
    }
    
    /// Persist a value to the Keychain. If `value` is nil, then any persisted value is deleted.
    internal func save<T: NSSecureCoding>(_ value: T?, forKey key: String) {
        let query = queryForKey(key)
        
        guard let object = value else {
            SecItemDelete(query as CFDictionary)
            return
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        let fetched: T? = fetch(key)
        
        if fetched != nil {
            let attributes = [kSecValueData as String: data]
            SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        } else {
            var mutableQuery = query
            mutableQuery[kSecValueData as String] = data
            mutableQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock as String
            mutableQuery[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked as String
            let _ = SecItemAdd(mutableQuery as CFDictionary, nil)
        }
    }
    
    private func queryForKey(_ key: String?) -> Dictionary<String, Any> {
        var q = [kSecClass as String: kSecClassGenericPassword as String,
                 kSecAttrService as String: name]
        
        if let key = key {
            q[kSecAttrAccount as String] = key
        }
        
        if let group = accessGroup {
            q[kSecAttrAccessGroup as String] = group
        }
        
        q[kSecAttrSynchronizable as String] = kSecAttrSynchronizableAny as String
        
        return q
    }
}

//
//  UserDefaults.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/30/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    public subscript<T>(_ key: String) -> T? {
        get {
            if T.self == Bool.self { return bool(forKey: key) as? T }
            if T.self == Int.self { return integer(forKey: key) as? T }
            if T.self == Float.self { return float(forKey: key) as? T }
            if T.self == Double.self { return double(forKey: key) as? T }
            if T.self == String.self { return string(forKey: key) as? T }
            if T.self == Data.self { return data(forKey: key) as? T }
            if T.self == URL.self { return url(forKey: key) as? T }
            if T.self == Array<String>.self { return stringArray(forKey: key) as? T }
            if T.self == Array<AnyObject>.self { return array(forKey: key) as? T }
            if T.self == Dictionary<String, AnyObject>.self { return dictionary(forKey: key) as? T }
            return object(forKey: key) as? T
        }
        set {
            guard let value = newValue else { return set(nil, forKey: key) }
            
            if T.self == Bool.self { return set((value as? Bool) ?? false, forKey: key) }
            if T.self == Int.self { return set((value as? Int) ?? 0, forKey: key) }
            if T.self == Float.self { return set((value as? Float) ?? 0, forKey: key) }
            if T.self == Double.self { return set((value as? Double) ?? 0, forKey: key) }
            if T.self == URL.self { return set(value as? URL, forKey: key) }
            set(value, forKey: key)
        }
    }
    
}

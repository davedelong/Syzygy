//
//  AnyObject+Property.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 5/18/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

public protocol PropertyTaking: AnyObject { }

public extension PropertyTaking {
    
    @discardableResult
    func take<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, from property: Property<T>) -> Disposable {
        return property.observe { [weak self] value in
            self?[keyPath: keyPath] = value
        }
    }
    
    @discardableResult
    func take<T>(_ keyPath: ReferenceWritableKeyPath<Self, T?>, from property: Property<T>) -> Disposable {
        return property.observe { [weak self] value in
            self?[keyPath: keyPath] = value
        }
    }
}

extension NSObject: PropertyTaking { }

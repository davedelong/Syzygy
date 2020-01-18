//
//  Property.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core
import StandardLibrary

public typealias PropertyObserver<T> = (T) -> Void

public enum PropertyError: Error {
    case missingInitialValue
}

public class Property<T> {
    private let _lock = NSRecursiveLock()
    private var _value: T
    
    private let _observers = Bag<PropertyObserver<T>>()
    private let _cleanup = CompositeDisposable()
    
    public var value: T {
        _lock.lock()
        let value = _value
        _lock.unlock()
        return value
    }
    
    public init(_ value: T) {
        _value = value
    }
    
    @discardableResult
    private func addObserver(sendCurrentValue: Bool = true, _ observer: @escaping PropertyObserver<T>) -> Disposable {
        _lock.lock()
        let uuid = _observers.add(observer)
        if sendCurrentValue == true {
            observer(_value)
        }
        _lock.unlock()
        
        // pull these variables out separately to avoid retaining self in the block
        let lock = _lock
        let bag = _observers
        let d = ActionDisposable {
            lock.lock()
            bag.remove(uuid)
            lock.unlock()
        }
        
        // we will automatically clean up this disposable when we deinit
        // this is primarily to guarantee that the disposable is properly marked as "disposed"
        // for whomever happens to be hanging on to it outside of the property
        addCleanupDisposable(d)
        return d
    }
    
    @discardableResult
    public func observe(_ observer: @escaping PropertyObserver<T>) -> Disposable {
        return addObserver(sendCurrentValue: true, observer)
    }
    
    @discardableResult
    public func observeNext(_ observer: @escaping PropertyObserver<T>) -> Disposable {
        return addObserver(sendCurrentValue: false, observer)
    }
    
    public func addCleanupDisposable(_ disposable: Disposable) {
        _cleanup.add(disposable)
    }
    
    internal func potentiallyModifyValue(_ valueModifier: (T) -> T?) {
        _lock.lock()
        if let newValue = valueModifier(_value) {
            _value = newValue
            for o in _observers.list() {
                o(newValue)
            }
        }
        _lock.unlock()
    }
    
    internal func setValue(_ value: T) {
        potentiallyModifyValue { _ in return value }
    }
}

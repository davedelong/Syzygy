//
//  KVOProperty.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

private var KVOHelperProperty: UInt8 = 0
public final class KVOProperty<T>: Property<T> {
    
    private var helper: KVOHelper<T>?
    
    public init(object: NSObject, keyPath: String) throws {
        guard let value = object.value(forKeyPath: keyPath) else {
            throw PropertyError.missingInitialValue
        }
        guard let typed = value as? T else {
            throw PropertyError.missingInitialValue
        }
        super.init(typed)
        helper = KVOHelper(object: object, keyPath: keyPath, property: self)
    }
    
    public init(object: NSObject, keyPath: String, initialValue: T) {
        let value = object.value(forKeyPath: keyPath)
        let typed = value as? T
        let initial = typed ?? initialValue
        super.init(initial)
        helper = KVOHelper(object: object, keyPath: keyPath, property: self)
    }
    
}

private class KVOHelper<T>: NSObject {
    private weak var object: NSObject?
    private let keyPath: String
    private weak var property: KVOProperty<T>?
    
    init(object: NSObject, keyPath: String, property: KVOProperty<T>) {
        self.object = object
        self.keyPath = keyPath
        self.property = property
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: [], context: nil)
        object.setAssociatedObject(self, forKey: &KVOHelperProperty)
    }
    
    deinit {
        object?.removeObserver(self, forKeyPath: keyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        guard keyPath == self.keyPath else { return }
        guard let nsObject = object as? NSObject else { return }
        guard nsObject == self.object else { return }
        guard let value = nsObject.value(forKeyPath: keyPath) else { return }
        guard let typed = value as? T else { return }
        property?.setValue(typed)
    }
    
}

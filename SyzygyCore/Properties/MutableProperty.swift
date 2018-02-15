//
//  MutableProperty.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation


/// A MutableProperty<T> is an observable property that:
/// - Has a modifiable value
/// - Notifies observers of modifications
public final class MutableProperty<T>: Property<T> {
    
    /// Atomically gets and sets the property's value and notifies all attached observers.
    public override var value: T {
        get { return super.value }
        set { setValue(newValue) }
    }
    
    
    /// Atomically modify the property's value
    ///
    /// - Parameter modify: The block to modify the property's value. This block will be called with the current value,
    ///        and the return value of the block will be the new value.
    public func modify( _ modify: (T) -> T) {
        potentiallyModifyValue(modify)
    }
    

    /// Cause the property to fire all of its observers with the current value
    public func tickle() {
        potentiallyModifyValue { $0 }
    }
}

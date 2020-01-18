//
//  MirroredProperty.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core


/// A MirroredProperty<T> is an observable property that:
/// - Has a current value. This value cannot be modified directly.
/// - Can be made to mirror another property
public final class MirroredProperty<T>: Property<T> {
    private let currentTakerDisposable = Atomic<Disposable?>(nil)

    /// The default initializer of a `MirroredProperty`
    ///
    /// - Parameter value: The initial value of the property
    public override init(_ value: T) {
        super.init(value)
    }
    
    /// Initialize a `MirroredProperty` that takes its value changes from the provided `Property`.
    ///
    /// - Parameter property: The `Property` from where values will be taken
    public convenience init(mirroring property: Property<T>) {
        self.init(property.value)
        takeValue(from: property)
    }
    
    deinit {
        let taker = currentTakerDisposable.swap(nil)
        taker?.dispose()
    }
    
    /// Changes the underlying source from where values are taken
    ///
    /// - Parameter property: The `Property` from where future values will be taken. May be `nil` to indicate no more mirroring should occur.
    public func takeValue(from property: Property<T>?) {
        currentTakerDisposable.modify { current in
            current?.dispose()
            return property?.observe { [weak self] in
                self?.setValue($0)
            }
        }
    }
    
    /// A convenience method to indicate that a `MirroredProperty` should no longer reflect the values of its underlying `Property`.
    public func stopTakingValue() {
        takeValue(from: nil)
    }
}

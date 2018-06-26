//
//  Property+Map.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property {
    
    /// Transform a `Property`'s value
    ///
    /// - Parameter mapper: The block to transform a passed value into a new type
    /// - Returns: A new `Property` that reflects the transformed values
    public func map<U>(_ mapper: @escaping (T) -> U) -> Property<U> {
        let p = MutableProperty(mapper(value))
        observeNext { p.value = mapper($0) }
        return p
    }
    
//    public func compactMap<U>(initialValue: U, _ mapper: @escaping (T) -> U?) -> Property<U> {
//        let initial = mapper(value) ?? initialValue
//        let p = MutableProperty(initial)
//        observeNext { new in p.potentiallyModifyValue(mapper(new)) }
//        return p
//    }
//    
//    public func compactMap<U>(_ mapper: @escaping (T) -> U?) throws -> Property<U> {
//        guard let initial = mapper(value) else { throw PropertyError.missingInitialValue }
//        let p = MutableProperty(initial)
//        observeNext { new in p.potentiallyModifyValue(mapper(new)) }
//        return p
//    }
    
    /// Transform a `Property`'s value into a new `Property`, from which new values will be taken
    ///
    /// - Parameter mapper: The block to transform a passed value into a new property.
    ///        The returned property will take its values from the most recent property returned from the `mapper`
    /// - Returns: A new `Property` that reflects the latest mirrored value
    public func flatMap<U>(_ mapper: @escaping (T) -> Property<U>) -> Property<U> {
        let p = MirroredProperty(mirroring: mapper(value))
        
        observeNext { newValue in
            let nextSource = mapper(newValue)
            p.takeValue(from: nextSource)
        }
        
        return p
    }
    
    /// Transform a `Property`'s value into a new `Property`, from which new values will be taken
    ///
    /// - Parameter mapper: The block to transform a passed value into a new, but potentially `nil`, property.
    ///        The returned property will take its values from the most recently return property (or none at all)
    /// - Returns: A new `Property` that reflects the latest mirrored value
    /// - Throws: `.missingInitialValue` if the mapper does not return a Property for the source's current value
    public func flatMap<U>(_ mapper: @escaping (T) -> Property<U>?) throws -> Property<U> {
        guard let initial = mapper(value) else {
            throw PropertyError.missingInitialValue
        }
        let p = MirroredProperty(mirroring: initial)
        
        observeNext { newValue in
            let nextSource = mapper(newValue)
            p.takeValue(from: nextSource)
        }
        
        return p
    }
    
    /// Transform a `Property`'s value into a new `Property`, from which new values will be taken
    ///
    /// - Parameters:
    ///   - initialValue: An initial value for the returned property, if the `mapper` does not supply a `Property` to mirror
    ///   - mapper: The block to transform a passed value into a new, but potentially `nil`, property.
    ///        The returned property will take its values from the most recently return property (or none at all)
    /// - Returns: A new `Property` that mirrors the latest property returned from the `mapper`
    public func flatMap<U>(initialValue: U, _ mapper: @escaping (T) -> Property<U>?) -> Property<U> {
        let p: MirroredProperty<U>
        if let source = mapper(value) {
            p = MirroredProperty(mirroring: source)
        } else {
            p = MirroredProperty(initialValue)
        }
        
        observeNext { newValue in
            let nextSource = mapper(newValue)
            p.takeValue(from: nextSource)
        }
        
        return p
    }
}

public extension Property where T: Hashable {
    
    /// Transform a `Property`'s value
    ///
    /// - Parameter mapper: The block to transform a passed value into a new type
    /// - Returns: A new `Property` that reflects the transformed values
    public func mapReusingValues<U>(_ mapper: @escaping (T) -> U) -> Property<U> {
        var producedValues = Dictionary<T, U>()
        let itemMapper: (T) -> U = { v in
            return producedValues.value(for: v, builder: mapper)
        }
        
        let p = MutableProperty(itemMapper(value))
        
        observeNext {
            p.value = itemMapper($0)
        }
        return p
    }
    
}

public extension Property where T: Collection, T.Element: Hashable {
    
    /// Transform a `Property`'s value
    ///
    /// - Parameter mapper: The block to transform a passed value into a new type
    /// - Returns: A new `Property` that reflects the transformed values
    public func mapItemsReusingValues<U>(_ mapper: @escaping (T.Element) -> U) -> Property<Array<U>> {
        var producedValues = Dictionary<T.Element, U>()
        let collectionMapper: (T) -> Array<U> = { c in
            return c.map { producedValues.value(for: $0, builder: mapper) }
        }
        
        let p = MutableProperty(collectionMapper(value))
        
        observeNext {
            p.value = collectionMapper($0)
        }
        return p
    }
    
    /// Transform a `Property`'s value
    ///
    /// - Parameter mapper: The block to transform a passed value into a new type
    /// - Returns: A new `Property` that reflects the transformed values
    public func flatMapItemsReusingValues<U>(_ mapper: @escaping (T.Element) -> U?) -> Property<Array<U>> {
        var producedValues = Dictionary<T.Element, U>()
        let collectionMapper: (T) -> Array<U> = { c in
            return c.compactMap { producedValues.value(for: $0, builder: mapper) }
        }
        
        let p = MutableProperty(collectionMapper(value))
        
        observeNext {
            p.value = collectionMapper($0)
        }
        return p
    }
    
}

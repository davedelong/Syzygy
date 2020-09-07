//
//  File.swift
//  
//
//  Created by Dave DeLong on 8/29/20.
//

import SwiftUI
import Combine

@propertyWrapper
@dynamicMemberLookup
public struct Transaction<Value>: DynamicProperty {
    @State private var derived: Value
    @Binding private var source: Value

    fileprivate init(source: Binding<Value>) {
        self._source = source
        self._derived = State(wrappedValue: source.wrappedValue)
    }

    public var wrappedValue: Value {
        get { derived }
        nonmutating set { derived = newValue }
    }

    public var projectedValue: Transaction<Value> { self }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        return $derived[dynamicMember: keyPath]
    }

    public var binding: Binding<Value> { $derived }

    public func commit() {
        source = derived
    }
    public func rollback() {
        derived = source
    }
}

extension Transaction where Value: Equatable {
    public var hasChanges: Bool { return source != derived }
}

extension Binding {
    public func transaction() -> Transaction<Value> { .init(source: self) }
}

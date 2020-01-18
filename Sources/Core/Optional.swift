//
//  Optional.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype ValueType
    var optionalValue: ValueType? { get }
    init(_ value: ValueType?)
}

extension Optional: OptionalType {
    public typealias ValueType = Wrapped
    public var optionalValue: ValueType? { return self }
    public init(_ value: Wrapped?) {
        self = value
    }
}

infix operator !!: NilCoalescingPrecedence

@_transparent
public func !!<T>(value: T?, error: @autoclosure () -> String) -> T {
    if let value = value { return value }
    fatalError(error())
}

@_transparent
public func !!<T>(value: T?, error: @autoclosure () -> Abort.Reason) -> T {
    if let value = value { return value }
    Abort.because(error())
}

infix operator ?!: NilCoalescingPrecedence

@_transparent
public func ?!<T: OptionalType>(value: T, error: @autoclosure () -> Error) throws -> T.ValueType {
    if let value = value.optionalValue { return value }
    throw error()
}


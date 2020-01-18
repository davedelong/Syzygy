//
//  Disposable.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol Disposable {
    var disposed: Bool { get }
    func dispose()
}

public final class BasicDisposable: Disposable {
    private let storage = Atomic(false)
    public init() { }
    
    public var disposed: Bool { return storage.value }
    public func dispose() { storage.swap(true) }
}

public final class ActionDisposable: Disposable {
    private let storage: Atomic<(() -> Void)?>
    public var disposed: Bool { return storage.value == nil }
    
    public init(_ block: @escaping () -> Void) {
        storage = Atomic(block)
    }
    
    public func dispose() {
        let block = storage.swap(nil)
        block?()
    }
}

public final class CompositeDisposable: Disposable {
    private let storage = Atomic<Array<Disposable>?>([])
    
    public var disposed: Bool { return storage.value == nil }
    
    public init() { }
    
    deinit { dispose() }
    
    public func dispose() {
        let actions = storage.swap(nil)
        actions?.forEach { $0.dispose() }
    }
    
    public func add(_ disposable: Disposable) {
        storage.modify { current in
            guard var modified = current else {
                disposable.dispose()
                return nil
            }
            modified.append(disposable)
            return modified
        }
    }
    
    public func add(_ block: @escaping () -> Void) {
        add(ActionDisposable(block))
    }
}

public func +=(lhs: CompositeDisposable, rhs: Disposable?) -> Void {
    guard let rhs = rhs else { return }
    return lhs.add(rhs)
}

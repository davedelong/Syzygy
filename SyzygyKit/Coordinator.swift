//
//  Coordinator.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 6/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Abort.Reason {
    public static let missingParent = Abort.Reason("Coordinator does not have a parent")
    public static let recursiveChild = Abort.Reason("Coordinator cannot be its own child")
    public static let unbalancedStop = Abort.Reason("Coordinator.stop() has been invoked too many times")
    public static let existingRoot = Abort.Reason("A root coordinator already exists")
    public static let unstopped = Abort.Reason("This coordinator has not been stopped")
}

private var _rootCoordinator: Coordinator?

open class Coordinator: PlatformResponder {
    
    public enum Kind {
        case root
        case normal
    }
    
    open var rootViewController: PlatformViewController {
        Abort.because(.mustBeOverridden)
    }
    
    public private(set) weak var parent: Coordinator?
    public private(set) var children = Array<Coordinator>()
    
    public let disposable = CompositeDisposable()
    
    private weak var _nextResponder: PlatformResponder?
    
    private let _startCount = Atomic<Int>(0)
    public var started: Bool { return _startCount.with { $0 > 0 } }
    
    public init(kind: Kind = .normal) {
        Assert.isMainThread()
        
        super.init()
        
        if kind == .root {
            Abort.if(_rootCoordinator != nil, because: .existingRoot)
            _rootCoordinator = self
            #if BUILDING_AS_DESKTOP_APP
            _nextResponder = NSApplication.shared
            #elseif BUILDING_AS_MOBILE_APP
            _nextResponder = UIApplication.shared
            #endif
        }
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    deinit {
        Abort.if(started == true, because: .unstopped)
        
        if self == _rootCoordinator {
            _rootCoordinator = nil
        }
    }
    
    open override var next: PlatformResponder? {
        return _nextResponder
    }
    
    private var _isOrphaned: Bool {
        return self.parent == nil && self != _rootCoordinator
    }
    
    /// Instruct the coordinator to begin its flow
    ///
    /// It's up to the coordinator to interpret what this means.
    /// - For a model coordinator, perhaps it means to begin connecting
    /// to the model storage services or to begin vending model objects.
    /// - For a UI coordinator, it might mean to show a window, or present
    /// a modal dialog.
    /// - For a coordinator that composes other coordinators (such as an
    /// app-level coordinator) this likely means to pass on the instruction
    /// to its sub-coordinators.
    ///
    /// If you override this method, you *must* call `super`
    open func start() {
        Abort.if(self._isOrphaned, because: .missingParent)
        Assert.isMainThread()
        _startCount.modify { $0 + 1 }
        if _startCount.value == 1 {
            children.forEach { $0.start() }
        }
    }
    
    /// Instruct the coordinator to stop its flow.
    ///
    /// It's up to the coordinator to interpret what this means.
    /// - For a model coordinator, it might mean to flush its in-memory
    /// caches to disk, or to tear down a Core Data stack.
    /// - For a UI coordinator, it might mean to close a window or to
    /// dismiss a modal dialog
    /// - For a composing coordinator, this like means to pass on the
    /// instructor to its sub-coordinators.
    ///
    /// If you override this method, you *must* call `super`
    open func stop() {
        Abort.if(self._isOrphaned, because: .missingParent)
        Assert.isMainThread()
        _startCount.modify { $0 - 1 }
        Abort.if(_startCount.value < 0, because: .unbalancedStop)
        if _startCount.value == 0 {
            children.forEach { $0.stop() }
        }
    }
    
    
    /// Adds a child coordinator to this coordinator.
    ///
    /// Child coordinators are how we can maintain proper responder chain
    /// hierarchy. If the passed `child` is already a child of another
    /// coordinator, then it is first removed from its existing
    /// parent coordinator.
    ///
    /// If you override this method, you *must* call `super`
    ///
    /// - Parameter child: The `Coordinator` to add as a child
    open func addChild(_ child: Coordinator) {
        Abort.if(child.parent == self, because: .recursiveChild)
        
        if let existingParent = child.parent {
            existingParent.removeChild(child)
        }
        children.append(child)
        child.parent = self
        child._nextResponder = self
        if started {
            child.start()
        }
    }
    
    
    /// Removes a child coordinator from this coordinator
    ///
    /// If the passed `child` is not a child of this coordinator,
    /// then this method has no effect.
    ///
    /// If you override this method, you *must* call `super`
    ///
    /// - Parameter child: The `Coordinator` to remove
    open func removeChild(_ child: Coordinator) {
        guard child.parent === self else { return }
        guard let index = children.index(where: { $0 === child }) else { return }
        child.stop()
        child.parent = nil
        child._nextResponder = nil
        children.remove(at: index)
    }
    
}

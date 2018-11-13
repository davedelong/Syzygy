//
//  NSObject.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

private var DeallocHelperKey: UInt8 = 0

public enum AssociationPolicy {
    case assign
    case retain
    case copy
    case retainNonatomic
    case copyNonatomic
    
    fileprivate var policy: objc_AssociationPolicy {
        switch self {
            case .assign: return .OBJC_ASSOCIATION_ASSIGN
            case .retain: return .OBJC_ASSOCIATION_RETAIN
            case .copy: return .OBJC_ASSOCIATION_COPY
            case .retainNonatomic: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .copyNonatomic: return .OBJC_ASSOCIATION_COPY_NONATOMIC
        }
    }
}

public extension NSObjectProtocol {
    
    public func setAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer, policy: AssociationPolicy = .retain) {
        objc_setAssociatedObject(self, key, object, policy.policy)
    }
    
    public func associatedObject<T>(for key: UnsafeRawPointer, create: (() -> T?)? = nil) -> T? {
        var object = objc_getAssociatedObject(self, key) as? T
        if object == nil, let creator = create {
            object = creator()
            setAssociatedObject(object, forKey: key)
        }
        return object
    }
    
    public func addDeallocHandler(_ handler: @escaping () -> Void) {
        let helper = associatedObject(for: &DeallocHelperKey, create: { DeallocHelper() })
        helper?.handlers.append(handler)
    }
    
}

public extension NSObject {
    
    public func overrides(_ selector: Selector, upTo targetParent: AnyClass? = nil) -> Bool {
        guard let myIMP = method(for: selector) else { return false }
        
        var parentClass: AnyClass? = type(of: self)
        while let parent = parentClass {
            let parentIMP = parent.instanceMethod(for: selector)
            
            if parentIMP != nil && parentIMP != myIMP { return true }
            if parent == targetParent { break }
            
            parentClass = class_getSuperclass(parentClass)
        }
        
        return false
    }
    
}

private class DeallocHelper: NSObject {
    var handlers = Array<() -> Void>()
    
    deinit {
        handlers.forEach { $0() }
    }
}

//
//  WeakBox.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public class WeakBox<T: AnyObject> {
    private weak var _value: T?
    public var value: T? { return _value }
    
    public init(_ value: T) {
        _value = value
    }
}

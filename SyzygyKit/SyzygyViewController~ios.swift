//
//  SyzygyViewController~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension SyzygyViewController {
    
    public typealias TransitionOptions = UIView.AnimationOptions
    
    internal func _setChildren(_ newChildren: Array<PlatformViewController>) {
        let kids = children
        kids.forEach { $0.removeFromParent() }
        newChildren.forEach {
            addChild($0)
            $0.didMove(toParent: self)
        }
    }
    
    internal func _platformViewDidLoad() {
        
    }
    
}

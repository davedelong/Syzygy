//
//  SyzygyViewController~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class SyzygyViewController: _SyzygyViewControllerBase {
    
    public typealias TransitionOptions = UIView.AnimationOptions
    
    public func updateChildren(_ newChildren: Array<PlatformViewController>) {
        let kids = children
        kids.forEach { $0.removeFromParent() }
        newChildren.forEach {
            addChild($0)
            $0.didMove(toParent: self)
        }
    }
    
    open override func addChild(_ childController: PlatformViewController) {
        super.addChild(childController)
        if let child = childController as? SyzygyViewController {
            if childController.parent == self {
                child.parentWantsSelection.takeValue(from: wantsSelection)
            }
        }
    }
    
    open override func removeFromParent() {
        super.removeFromParent()
        parentWantsSelection.takeValue(from: .false)
    }
    
}

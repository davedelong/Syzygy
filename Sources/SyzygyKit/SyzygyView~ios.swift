//
//  SyzygyView~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_MOBILE

public class SyzygyView: PlatformView {
    
    public internal(set) weak var controller: _SyzygyViewControllerBase?
    
    private var delegatingSystemLayoutSize = false
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        
        if let c = controller, delegatingSystemLayoutSize == false {
            delegatingSystemLayoutSize = true
            size = c.viewSystemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
            delegatingSystemLayoutSize = false
        }
        
        return size        
    }
    
    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        print("HERE2")
        return super.systemLayoutSizeFitting(targetSize)
    }
    
}

#endif

//
//  UIView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MOBILE

import UIKit

public extension UIView {
    
    func addTapAction(_ block: @escaping () -> Void) {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.addAction(block)
        addGestureRecognizer(tap)
    }
    
    // this is to allow a shared macOS views to override -updateLayer
    // For example, see ShapeView.swift
    @objc func updateLayer() { }
    
}

#endif

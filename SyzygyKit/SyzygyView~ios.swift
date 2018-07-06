//
//  SyzygyView~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class SyzygyView: PlatformView {
    
    public internal(set) weak var controller: _SyzygyViewControllerBase?
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        controller?.viewDidMoveToSuperview(self.superview)
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        controller?.viewDidMoveToWindow(self.window)
    }
    
}

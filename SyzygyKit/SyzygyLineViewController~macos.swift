//
//  SyzygyLineViewController~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

internal extension SyzygyLineViewController {
    
    static func makeLine(orientation: Orientation) -> SyzygyView {
        let s = SyzygyView()
        let b: NSBox
        if orientation == .vertical {
            b = NSBox(orientation: .vertical)
        } else {
            b = NSBox(orientation: .horizontal)
        }
        s.embedSubview(b)
        return s
    }
    
}

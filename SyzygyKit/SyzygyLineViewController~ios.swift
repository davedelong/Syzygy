//
//  SyzygyLineViewController~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

internal extension SyzygyLineViewController {
    
    static func makeLine(orientation: Orientation) -> SyzygyView {
        let v = SyzygyView()
        if orientation == .vertical {
            v.width.constraint(equalToConstant: 1.0).isActive = true
        } else {
            v.height.constraint(equalToConstant: 1.0).isActive = true
        }
        v.backgroundColor = UIColor.lightGray
        return v
    }
    
}

//
//  SyzygyLineViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class SyzygyLineViewController: SyzygyViewController {
    
    public enum Orientation {
        case horizontal
        case vertical
    }
    
    private let orientation: Orientation
    
    public init(orientation: Orientation) {
        self.orientation = orientation
        super.init(ui: .empty)
    }
    
    required init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    public override func loadView() {
        view = SyzygyLineViewController.makeLine(orientation: orientation)
    }
    
}

#if BUILDING_FOR_MAC

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

#elseif BUILDING_FOR_MOBILE

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

#endif

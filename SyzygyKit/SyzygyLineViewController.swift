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

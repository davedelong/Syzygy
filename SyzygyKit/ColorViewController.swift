//
//  ColorViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class ColorViewController: SyzygyViewController {
    
    private let color: Color
    
    public init(color: Color) {
        self.color = color
        super.init(ui: .empty)
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        syzygyView.backgroundColor = color.color
    }
    
}

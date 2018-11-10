//
//  SeparatorItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class SeparatorItem: DataSourceItemCell {
    
    private let lineHeight: NSLayoutConstraint
    
    public override init() {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        lineHeight = l.heightAnchor.constraint(equalToConstant: 1.0)
        
        super.init()
        contentView.addSubview(l)
        
        NSLayoutConstraint.activate([
            l.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            l.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            contentView.trailingAnchor.constraint(equalTo: l.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: l.bottomAnchor),
            
            lineHeight
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func didMoveToWindow() {
        let scale = max(window?.screen.scale ?? 1.0, 1.0)
        let onePixel = 1 / scale
        lineHeight.constant = onePixel
    }
    
}

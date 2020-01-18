//
//  LoadingItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class LoadingItem: DataSourceItemCell {
    
    public override init() {
        super.init()
        
        selectable = false
        
        let ai = UIActivityIndicatorView(style: .gray)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        
        contentView.addSubview(ai)
        
        NSLayoutConstraint.activate([
            ai.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ai.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            ai.top.constraint(greaterThanOrEqualToSystemSpacingBelow: contentView.top),
            ai.leading.constraint(greaterThanOrEqualToSystemSpacingAfter: contentView.leading),
            
            contentView.height.constraint(greaterThanOrEqualToConstant: 44.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

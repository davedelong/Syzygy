//
//  ActionListItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/9/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class ActionListItem: DataSourceItemCell {
    
    public init(actions: Array<Action>) {
        super.init()
        
        let views = actions.map { a -> UIView in
            let button = InfoActionButton.make()
            button.titleLabel?.text = a.name
            button.imageView?.image = a.image
            
            button.addTapAction { a.handler(nil) }
            button.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9098039216, blue: 0.8980392157, alpha: 1)
            button.layer.cornerRadius = 8
            return button
        }
        
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        embedSubview(stack, margins: PlatformEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

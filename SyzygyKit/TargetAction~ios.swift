//
//  TargetAction~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

extension UIBarButtonItem: TargetActionProtocol { }

public extension UIBarButtonItem {
    
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, style: style, target: nil, action: nil)
    }
    
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
    }
    
    public convenience init(title: String?, style: UIBarButtonItem.Style) {
        self.init(title: title, style: style, target: nil, action: nil)
    }
    
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionBlock: @escaping (Any) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, actionBlock: @escaping (Any) -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
    public convenience init(title: String?, style: UIBarButtonItem.Style, actionBlock: @escaping (Any) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, actionBlock: @escaping (Any) -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        self.actionBlock = actionBlock
    }
    
}

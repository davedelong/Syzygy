//
//  UITableViewCell.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension UITableViewCell {
    
    public static func nib() -> UINib? {
        return UINib(nibName: "\(self)", bundle: Bundle(for: self))
    }
    
}

open class ViewControllerTableViewCell: UITableViewCell {
    
    public init(content: UIViewController) {
        super.init(style: .default, reuseIdentifier: "\(type(of: content))")
        
        let size = content.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var frame = self.frame
        frame.size.height = size.height
        self.frame = frame
        
        contentView.embedSubview(content.view)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override var frame: CGRect {
        get { return super.frame }
        set { super.frame = newValue }
    }
    
}

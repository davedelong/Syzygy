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

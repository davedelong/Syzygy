//
//  NSTabViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

import Foundation

public protocol ExpressibleAsTabViewItem {
    
    var tabViewItem: NSTabViewItem { get }
    
}

#endif

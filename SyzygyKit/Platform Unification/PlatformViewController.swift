//
//  PlatformViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 6/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias PlatformViewController = NSViewController
#else
public typealias PlatformViewController = UIViewController
#endif

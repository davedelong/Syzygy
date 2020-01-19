//
//  GestureRecognizer~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_MAC

public typealias PlatformGestureRecognizer = NSGestureRecognizer

public typealias PlatformClickGestureRecognizer = NSClickGestureRecognizer

public typealias PlatformPanGestureRecognizer = NSPanGestureRecognizer
public typealias PlatformPinchGestureRecognizer = NSMagnificationGestureRecognizer
public typealias PlatformRotateGestureRecognizer = NSRotationGestureRecognizer

#elseif BUILDING_FOR_MOBILE

public typealias PlatformGestureRecognizer = UIGestureRecognizer

public typealias PlatformClickGestureRecognizer = UITapGestureRecognizer

public typealias PlatformPanGestureRecognizer = UIPanGestureRecognizer
public typealias PlatformPinchGestureRecognizer = UIPinchGestureRecognizer
public typealias PlatformRotateGestureRecognizer = UIRotationGestureRecognizer

#endif

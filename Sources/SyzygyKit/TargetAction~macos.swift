//
//  TargetAction~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

import Cocoa

extension NSControl: TargetActionProtocol { }
extension NSMenuItem: TargetActionProtocol { }

#endif

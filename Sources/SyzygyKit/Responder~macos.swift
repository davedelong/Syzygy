//
//  Responder~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public typealias PlatformResponder = NSResponder

public extension PlatformResponder {
    
    @objc var next: PlatformResponder? {
        return self.nextResponder
    }
    
}

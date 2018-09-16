//
//  Font.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if BUILDING_FOR_DESKTOP
public typealias PlatformFont = NSFont
#else
public typealias PlatformFont = UIFont
#endif

public extension PlatformFont {
    
    public func bolded() -> PlatformFont {
        var descriptor = self.fontDescriptor
        descriptor = descriptor.withSymbolicTraits(.traitBold) ?? descriptor
        return PlatformFont(descriptor: descriptor, size: pointSize)
    }
    
}

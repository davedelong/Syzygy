//
//  Color~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public typealias PlatformColor = NSColor

public extension PlatformColor {
    
    public static let defaultSelectionColor: PlatformColor = NSColor.selectedMenuItemColor
    
}

public extension Color {
    
    public var color: NSColor { return NSColor(cgColor: rawColor) !! "Unable to create color from \(rawColor)" }
    public init(color: NSColor) { self.rawColor = color.cgColor }

}

extension PlatformColor: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> PlatformColor? {
        if #available(OSX 10.13, *) {
            return NSColor(named: name)
        } else {
            // Fallback on earlier versions
            Abort.because("Need a named color")
        }
    }
}

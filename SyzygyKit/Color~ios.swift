//
//  Color~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public typealias PlatformColor = UIColor

public extension PlatformColor {
    
    static let defaultSelectionColor: PlatformColor = UIColor.blue
    
}

public extension Color {
    
    var color: UIColor { return UIColor(cgColor: rawColor) }
    init(color: UIColor) { self.rawColor = color.cgColor }
    
}

extension PlatformColor: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> UIColor? {
        return UIColor(named: name, in: bundle, compatibleWith: nil)
    }
}

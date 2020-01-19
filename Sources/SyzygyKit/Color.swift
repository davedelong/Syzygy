//
//  Color.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/3/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import Core

#if BUILDING_FOR_MAC

public typealias PlatformColor = NSColor

public extension PlatformColor {
    
    static let defaultSelectionColor: PlatformColor = NSColor.selectedMenuItemColor
    
}

public extension Color {
    
    var color: NSColor { return NSColor(cgColor: rawColor) !! "Unable to create color from \(rawColor)" }
    init(color: NSColor) { self.rawColor = color.cgColor }

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

#elseif BUILDING_FOR_MOBILE

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

#endif

public extension PlatformColor {
    
    convenience init?(hexString: String) {
        let c = Color(hexString: hexString)
        if let color = c?.color.cgColor {
            self.init(cgColor: color)
        } else {
            return nil
        }
    }
    
}

public struct Color {
    
    private static let sRGB = CGColorSpace(name: CGColorSpace.sRGB) !! "Unable to create sRGB color space"
    private static let displayP3 = CGColorSpace(name: CGColorSpace.displayP3) !! "Unable to create dP3 color space"
    
    public let rawColor: CGColor
    
    public init?(hexString: String) {
        let notHex = CharacterSet(charactersIn: "0123456789abcdefABCDEF").inverted
        var hex = hexString.components(separatedBy: notHex).joined(separator: "")
        let hexCharCount = hex.count
        guard hexCharCount == 3 || hexCharCount == 4 || hexCharCount == 6 || hexCharCount == 8 else { return nil }
        
        let needsDoubling = (hexCharCount < 6) // rgb or rgba
        if hexCharCount % 3 == 0 { hex += (needsDoubling ? "F" : "FF") }
        
        let componentLength = needsDoubling ? 1 : 2
        
        let characters = Array(hex)
        let red = String(characters[0 ..< componentLength])
        let green = String(characters[componentLength ..< (componentLength * 2)])
        let blue = String(characters[(componentLength * 2) ..< (componentLength * 3)])
        let alpha = String(characters[(componentLength * 3)...])
        
        let scan = { (component: String) -> CGFloat in
            let piece = component + (needsDoubling ? component : "")
            let result = UInt(piece, radix: 16) ?? 0
            return CGFloat(result) / 255
        }
        let components = [red, green, blue, alpha].map(scan)
        
        rawColor = CGColor(colorSpace: Color.sRGB, components: components) !! "Could not create sRGBA CGColor"
    }
    
}

public extension PlatformColor {
    static let action = PlatformColor(hexString: "007AFF")!
}

public extension R where T == PlatformColor {
    static let color = R<PlatformColor>()
}

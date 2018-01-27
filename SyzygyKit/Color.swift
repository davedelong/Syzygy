//
//  Color.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/3/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Color {
    
    private static let sRGB = CGColorSpace(name: CGColorSpace.sRGB) !! "Unable to create sRGB color space"
    private static let displayP3 = CGColorSpace(name: CGColorSpace.displayP3) !! "Unable to create dP3 color space"
    
    public let rawColor: CGColor
    
    #if os(macOS)
    
    public var color: NSColor { return NSColor(cgColor: rawColor) !! "Unable to create color from \(rawColor)" }
    public init(color: NSColor) { self.rawColor = color.cgColor }
    
    #else
    
    public var color: UIColor { return UIColor(cgColor: rawColor) }
    public init(color: UIColor) { self.rawColor = color.cgColor }
    
    #endif
    
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

public extension Color {
    public static let black = Color(color: .black)
    public static let darkGray = Color(color: .darkGray)
    public static let gray = Color(color: .gray)
    public static let lightGray = Color(color: .lightGray)
    public static let white = Color(color: .white)
    public static let clear = Color(color: .clear)
    
    public static let red = Color(color: .red)
    public static let orange = Color(color: .orange)
    public static let yellow = Color(color: .yellow)
    public static let green = Color(color: .green)
    public static let blue = Color(color: .blue)
    public static let purple = Color(color: .purple)
}

//
//  UTI+Defaults.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension UTI {
    private static let registeredDeviceTypes: Bool = {
        #if BUILDING_FOR_DESKTOP
        let fm = FileManager.default
        let coreTypes = AbsolutePath(fileSystemPath: "/System/Library/CoreServices/CoreTypes.bundle")
        let embeddedBundles = fm.contentsOfDirectory(at: coreTypes/"Contents"/"Library").filter { $0.extension == "bundle" }
        
        let paths = [coreTypes] + embeddedBundles
        
        let ok = paths.reduce(true) { (soFar, path) -> Bool in
            guard FileManager.default.folderExists(atPath: path) else { return soFar }
            return soFar && LSDatabase.shared.register(path, update: false)
        }
        
        return ok
        #else
        return false
        #endif
    }()
    
    public static let data = UTI(kUTTypeData)
    
    public static let app = UTI(kUTTypeApplication)
    public static let appBundle = UTI(kUTTypeApplicationBundle)
    public static let ipa = UTI(rawValue: "com.apple.itunes.ipa")
    
    public static let publicDevice = UTI(rawValue: "public.device")
    
    public static let mac = UTI(rawValue: "com.apple.mac")
    public static let macLaptop = UTI(rawValue: "com.apple.mac.laptop")
    
    public static let iOS = UTI(rawValue: "com.apple.ios-device")
    public static let iPad = UTI(rawValue: "com.apple.ipad")
    public static let iPhone = UTI(rawValue: "com.apple.iphone")
    public static let watch = UTI(rawValue: "com.apple.watch")
    public static let tv = UTI(rawValue: "com.apple.apple-tv")
    
    public static let xcodeproj = UTI(rawValue: "com.apple.xcode.project")
    public static let xcworkspace = UTI(rawValue: "com.apple.dt.document.workspace")
    public static let playground = UTI(rawValue: "com.apple.dt.playground")
    
    public enum DeviceColor {
        case rgb(UInt8, UInt8, UInt8)
        case hex(String)
        case named(String)
    }
    
    /// Create a UTI to represent a physical device
    ///
    /// - Parameters:
    ///   - deviceType: A string identifying a device type. Ex: "iPhone5,3", "D10AP", "MacBook5,1", etc
    ///   - color: A string representing the color of the device hardware. This can be a 6-digit hex string ("e5bdb5"), a color ("yellow"), or an rgb tuple ("157,157,160")
    public convenience init?(deviceType: String, color: DeviceColor? = nil) {
        _ = UTI.registeredDeviceTypes
        
        var matches = UTI.UTIs(for: "com.apple.device-model-code", tag: deviceType, conformingTo: .publicDevice)
        
        let colorMatch: String
        switch color {
            case .rgb(let r, let g, let b)?:
                colorMatch = "@ECOLOR=\(r),\(g),\(b)"
                let colorMatches = UTI.UTIs(for: "com.apple.device-model-code", tag: deviceType+colorMatch, conformingTo: .publicDevice)
                matches.insert(contentsOf: colorMatches, at: 0)
            case .hex(let s)?:
                colorMatch = s
            case .named(let s)?:
                colorMatch = s
            default:
                colorMatch = deviceType
        }
        
        let declared = matches.filter { $0.isDeclared }
        
        let exactMatches = declared.filter { uti in
            let strings = uti.declaration.allStringValues()
            let anyMatch = strings.filter { $0.hasSuffix(colorMatch) }
            return anyMatch.isEmpty == false
        }
        
        let best = exactMatches.first ?? declared.first ?? matches.first
        guard let match = best else { return nil }
        self.init(rawValue: match.rawValue)
    }

    
}

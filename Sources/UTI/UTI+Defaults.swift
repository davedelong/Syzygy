//
//  UTI+Defaults.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Paths

public extension UTI {
    
    private static let registeredDeviceTypes: Bool = {
        #if BUILDING_FOR_DESKTOP
        let fm = FileManager.default
        let coreTypes = AbsolutePath(fileSystemPath: "/System/Library/CoreServices/CoreTypes.bundle")
        let coreTypesLibrary = coreTypes/"Contents"/"Library"
        let embeddedBundles = try? fm.contentsOfDirectory(atPath: coreTypesLibrary.fileSystemPath).filter { ($0 as NSString).pathExtension == "bundle" }
        
        let paths = [coreTypes] + (embeddedBundles ?? [])
        
        let ok = paths.reduce(true) { (soFar, path) -> Bool in
//            guard FileManager.default.folderExists(atPath: path) else { return soFar }
//            return soFar && LSDatabase.shared.register(AbsolutePath(path), update: false)
            return soFar
        }
        
        return ok
        #else
        return false
        #endif
    }()
    
    static let data = UTI(kUTTypeData)
    static let json = UTI(kUTTypeJSON)
    static let plainText = UTI(kUTTypePlainText)
    static let url = UTI(kUTTypeURL)
    
    static let app = UTI(kUTTypeApplication)
    static let appBundle = UTI(kUTTypeApplicationBundle)
    static let ipa = UTI(rawValue: "com.apple.itunes.ipa")
    
    static let publicDevice = UTI(rawValue: "public.device")
    
    static let mac = UTI(rawValue: "com.apple.mac")
    static let macLaptop = UTI(rawValue: "com.apple.mac.laptop")
    
    static let iOS = UTI(rawValue: "com.apple.ios-device")
    static let iPad = UTI(rawValue: "com.apple.ipad")
    static let iPhone = UTI(rawValue: "com.apple.iphone")
    static let watch = UTI(rawValue: "com.apple.watch")
    static let tv = UTI(rawValue: "com.apple.apple-tv")
    
    static let xcodeproj = UTI(rawValue: "com.apple.xcode.project")
    static let xcworkspace = UTI(rawValue: "com.apple.dt.document.workspace")
    static let playground = UTI(rawValue: "com.apple.dt.playground")
    
    static let png = UTI(kUTTypePNG)
    static let jpeg = UTI(kUTTypeJPEG)
    
    enum DeviceColor {
        case rgb(UInt8, UInt8, UInt8)
        case hex(String)
        case named(String)
    }
    
    /// Create a UTI to represent a physical device
    ///
    /// - Parameters:
    ///   - deviceType: A string identifying a device type. Ex: "iPhone5,3", "D10AP", "MacBook5,1", etc
    ///   - color: A string representing the color of the device hardware. This can be a 6-digit hex string ("e5bdb5"), a color ("yellow"), or an rgb tuple ("157,157,160")
    convenience init?(deviceType: String, color: DeviceColor? = nil) {
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

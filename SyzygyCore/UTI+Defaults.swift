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
        #if os(macOS)
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
    
    public convenience init?(deviceType: String, color: String? = nil, enclosureColor: String? = nil) {
        _ = UTI.registeredDeviceTypes
        
        let UTIChecker = { (type: String, modifier: String?) -> UTI? in
            let utis = UTI.UTIs(for: "com.apple.device-model-code", tag: type, conformingTo: UTI.publicDevice)
            
            let declared = utis.filter { $0.isDeclared }
            
            var matches = declared
            if let modifier = modifier {
                let color = modifier.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
                matches = matches.filter { $0.rawValue.hasSuffix(color) }
            }
            
            return matches.first
        }
        
        let matches = [UTIChecker(deviceType, enclosureColor), UTIChecker(deviceType, color), UTIChecker(deviceType, nil)].flatMap { $0 }
        
        guard let match = matches.first else { return nil }
        self.init(rawValue: match.rawValue)
    }

    
}

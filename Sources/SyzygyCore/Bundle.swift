//
//  Bundle.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import SyzygyCore_ObjC
import Core
import Structures

public extension Bundle {
    
    var infoPlist: Plist {
        #if BUILDING_FOR_MAC
        let infoPlistPath = path/"Contents"/"Info.plist"
        #else
        let infoPlistPath = path/"Info.plist"
        #endif
        return (try? Plist(contentsOf: infoPlistPath)) ?? .unknown
    }
    
    var entitlementsPlist: Plist {
        guard self === Bundle.main else { return .unknown }
        guard let data = EntitlementsData() else { return .unknown }
        return (try? Plist(data: data)) ?? .unknown
    }
    
    func nestedBundle(with identifier: Identifier<Bundle, String>) -> Bundle? {
        #if BUILDING_FOR_DESKTOP
            let bundlePath = AbsolutePath(bundleURL)
            let matches = LSDatabase.shared.paths(for: identifier.rawValue, containedWithin: bundlePath)
            if let path = matches.first, let bundle = Bundle(path: path) {
                return bundle
            }
        #endif
        
        let enumerator = FileManager.default.enumerator(at: bundleURL, includingPropertiesForKeys: [.isDirectoryKey])
        guard let iterator = enumerator else { return nil }
    
        while let next = iterator.nextObject() as? URL {
            let resourceValues = try? next.resourceValues(forKeys: [.isDirectoryKey])
            let isDirectory = resourceValues?.isDirectory ?? false
            guard isDirectory else { continue }
            
            let infoPlist = next.appendingPathComponent("Contents/Info.plist")
            guard FileManager.default.fileExists(atPath: infoPlist.path) else { continue }
            
            guard let bundle = Bundle(url: next) else { continue }
            guard bundle.identifier == identifier else { continue }
            return bundle
        }
        
        return nil
    }
    
}

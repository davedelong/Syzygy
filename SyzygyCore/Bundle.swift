//
//  Bundle.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Bundle {
    
    var path: AbsolutePath { return AbsolutePath(bundleURL) }
    
    var infoPlist: Plist {
        let infoPlistPath = path/"Contents"/"Info.plist"
//        guard let infoPlistPath = absolutePath(forResource:"Info", withExtension: "plist") else { return .unknown }
        return (try? Plist(contentsOf: infoPlistPath)) ?? .unknown
    }
    
    var bundleVersion: String {
        guard let version = object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return "unknown"
        }
        return version
    }
    
    var name: String {
        return (object(forInfoDictionaryKey: "CFBundleName") as? String) ??
        (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ??
        bundleIdentifier ??
        "SyzygyCore"
    }
    
    #if os(macOS)
    func pathForNestedBundle(with identifier: String) -> AbsolutePath? {
        let bundlePath = AbsolutePath(bundleURL)
        let matches = LSDatabase.shared.paths(for: identifier, containedWithin: bundlePath)
        return matches.first
    }
    #endif
    
}

//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation
import Core

public extension Bundle {
    
    var identifier: Identifier<Bundle, String>? {
        guard let id = bundleIdentifier else { return nil }
        return Identifier(rawValue: id)
    }

    
    var shortBundleVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var bundleVersion: String {
        return shortBundleVersion ??
            object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ??
            "unknown"
    }
    
    var name: String {
        return (object(forInfoDictionaryKey: "CFBundleName") as? String) ??
        (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ??
        bundleIdentifier ??
        "Syzygy"
    }

}

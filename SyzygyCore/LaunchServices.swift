//
//  LaunchServices.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

#if os(macOS)

public class LSDatabase {
    private let q = DispatchQueue(specificLabel: "LaunchServices")
    private var _pathCache = Dictionary<String, Array<AbsolutePath>>()
    
    public static let shared = LSDatabase()
    
    private init() { }
    
    public func register(_ path: AbsolutePath, update: Bool = true) -> Bool {
        let cfURL = path.fileURL as CFURL
        let status = LSRegisterURL(cfURL, update)
        return status == noErr
    }
    
    public func paths(for bundleIdentifier: String, containedWithin: AbsolutePath? = nil, cache: Bool = true) -> Array<AbsolutePath> {
        var paths: Array<AbsolutePath> = []
        
        q.sync {
            var results: Array<AbsolutePath>?
            if cache == true {
                results = _pathCache[bundleIdentifier]
            }
            if results == nil {
                let urlResults = (LSCopyApplicationURLsForBundleIdentifier(bundleIdentifier as CFString, nil)?.takeRetainedValue() as? Array<URL>)
                results = urlResults?.map { AbsolutePath($0) }
                _pathCache[bundleIdentifier] = results
            }
            paths = results ?? []
        }
        
        if let container = containedWithin {
            paths = paths.filter { container.contains($0) }
        }
        
        return paths
    }
    
}

#endif

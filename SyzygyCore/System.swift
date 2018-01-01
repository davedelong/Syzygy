//
//  System.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

#if os(macOS)

public let System = SystemType()

public final class SystemType {
    fileprivate init() { }
    
    private subscript(key: String) -> String? {
        get {
            var size: Int = 0
            sysctlbyname(key, nil, &size, nil, 0)
            
            guard size > 0 else { return nil }
            
            var value = Array<CChar>(repeating: 0, count: size)
            sysctlbyname(key, &value, &size, nil, 0)
            
            return String(cString: value)
        }
    }
    
    public lazy var model: String = {
        return self["hw.model"] ?? "Mac??,?"
    }()
    
    public lazy var buildVersion: String = {
        return self["kern.osversion"] ?? "0A00"
    }()
    
    public lazy var releaseVersion: String = {
        let osInfo = ProcessInfo.processInfo.operatingSystemVersion
        return "\(osInfo.majorVersion).\(osInfo.minorVersion).\(osInfo.patchVersion)"
    }()
}

#endif

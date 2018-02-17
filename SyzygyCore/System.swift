//
//  System.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

#if os(macOS)
    
import IOKit

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
    
    public lazy var modelUTI: UTI = {
        return UTI(deviceType: self.model) ?? .mac
    }()
    
    public lazy var buildVersion: String = {
        return self["kern.osversion"] ?? "0A00"
    }()
    
    public lazy var releaseVersion: String = {
        let osInfo = ProcessInfo.processInfo.operatingSystemVersion
        return "\(osInfo.majorVersion).\(osInfo.minorVersion).\(osInfo.patchVersion)"
    }()
    
    public lazy var serialNumber: String = {
        let expert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        let number = IORegistryEntryCreateCFProperty(expert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(expert)
        return (number?.takeUnretainedValue() as? String) ?? ""
    }()
    
    public lazy var computerName: String = {
        let h = Host.current()
        return h.localizedName ?? h.name ?? modelUTI.description
    }()
    

    /// Get the user-displayable product name ("MacBook Pro (15-inch, 2017)")
    /// This hits the network. You probably shouldn't invoke this on the main thread.
    public lazy var productName: String = {
        let defaultName = modelUTI.description
        
        let serial = String(self.serialNumber.suffix(4))
        guard let url = URL(string: "https://support-sp.apple.com/sp/product?cc=\(serial)") else { return defaultName }
        guard let data = try? Data(contentsOf: url) else { return defaultName }
        guard let string = String(data: data, encoding: .utf8) else { return defaultName }
        guard let match = string.match(regex: "<configCode>(.+?)</configCode>") else { return defaultName }
        return match[1] ?? defaultName
    }()
}

#endif

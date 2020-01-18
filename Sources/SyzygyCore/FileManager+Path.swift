//
//  FileManager+Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core
import Paths
import Structures

public extension FileManager {
    
    struct OpenWith {
        public let applicationPath: AbsolutePath
        public let bundleIdentifier: String
        public let bundleVersion: String
        
        public init(path: AbsolutePath, bundleIdentifier: String, bundleVersion: String) {
            self.applicationPath = path
            self.bundleIdentifier = bundleIdentifier
            self.bundleVersion = bundleVersion
        }
        
        public init(bundle: Bundle) {
            self.applicationPath = bundle.path
            self.bundleIdentifier = bundle.bundleIdentifier !! "Unable to get identifier of bundle \(bundle)"
            self.bundleVersion = bundle.bundleVersion
        }
    }

    func openFile(_ file: AbsolutePath, with: OpenWith?) {
        guard let openInfo = with else {
            file.setExtendedAttribute(named: "com.apple.LaunchServices.OpenWith", value: nil)
            return
        }
        
        let dictionary: Dictionary<String, Any> = [
            "path": openInfo.applicationPath.fileSystemPath,
            "bundleidentifier": openInfo.bundleIdentifier,
            "bundleversion": openInfo.bundleVersion,
            "version": 0
        ]
        let plist = Plist(dictionary)
        let data = try? plist.plistData(.binary)
        file.setExtendedAttribute(named: "com.apple.LaunchServices.OpenWith", value: data)
    }
    
    func openWithInfo(for file: AbsolutePath) -> OpenWith? {
        guard let plistData = file.extendedAttribute(named: "com.apple.LaunchServices.OpenWith") else { return nil }
        guard let plist = try? Plist(data: plistData) else { return nil }
        
        guard let path = plist["path"].string else { return nil }
        guard let vers = plist["bundleversion"].string else { return nil }
        guard let bid = plist["bundleidentifier"].string else { return nil }
        
        let p = AbsolutePath(fileSystemPath: path)
        return OpenWith(path: p, bundleIdentifier: bid, bundleVersion: vers)
    }
}

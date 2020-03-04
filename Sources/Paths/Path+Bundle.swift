//
//  Bundle+Path.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Bundle {
    
    var path: AbsolutePath { return AbsolutePath(bundleURL) }
    
    convenience init?(path: AbsolutePath) {
        self.init(url: path.fileURL)
    }
    
    func absolutePath(forResource name: String?, withExtension ext: String?) -> AbsolutePath? {
        guard let url = self.url(forResource: name, withExtension: ext) else { return nil }
        return AbsolutePath(url)
    }
    
    func absolutePath(forResource name: String?, withExtension ext: String?, subdirectory subpath: String?) -> AbsolutePath? {
        guard let url = self.url(forResource: name, withExtension: ext, subdirectory: subpath) else { return nil }
        return AbsolutePath(url)
    }
    
    func absolutePath(forResource name: String?, withExtension ext: String?, subdirectory subpath: String?, localization localizationName: String?) -> AbsolutePath? {
        guard let url = self.url(forResource: name, withExtension: ext, subdirectory: subpath, localization: localizationName) else { return nil }
        return AbsolutePath(url)
    }
    
    func absolutePaths(forResourcesWithExtension ext: String?, subdirectory subpath: String?) -> Array<AbsolutePath>? {
        guard let urls = self.urls(forResourcesWithExtension: ext, subdirectory: subpath) else { return nil }
        return urls.map { AbsolutePath($0) }
    }
    
    func absolutePaths(forResourcesWithExtension ext: String?, subdirectory subpath: String?, localization localizationName: String?) -> Array<AbsolutePath>? {
        guard let urls = self.urls(forResourcesWithExtension: ext, subdirectory: subpath, localization: localizationName) else { return nil }
        return urls.map { AbsolutePath($0) }
    }
}

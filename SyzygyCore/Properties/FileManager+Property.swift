//
//  FileManager+Property.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension FileManager {
    
    
    public func resolved(symlink: AbsolutePath, defaultResolution: AbsolutePath? = nil) -> Property<AbsolutePath> {
        let containingFolder = symlink.deletingLastComponent()
        var monitor: FileMonitor? = FileMonitor(path: containingFolder, events: [.write, .delete])
        
        let resolveSymlink: () -> AbsolutePath = {
            let resolved = symlink.resolvingSymlinks()
            
            var path = resolved
            if resolved == symlink, let d = defaultResolution {
                path = d
            }
            return path
        }
        
        let initialValue = resolveSymlink()
        let m = MutableProperty(initialValue)
        
        monitor?.handler = { [weak m] _ in
            m?.value = resolveSymlink()
            return nil // keep observing the same path
        }
        
        m.addCleanupDisposable(ActionDisposable {
            // this retains the monitor
            // but also cleans it up when the property goes away
            monitor = nil
        })
        
        return m
    }
    
    public func resolved(path: AbsolutePath) -> Property<AbsolutePath?> {
        guard let data = path.bookmarkData else { return Property(nil) }
        return resolved(bookmark: data)
    }
    
    public func resolved(bookmark: Data) -> Property<AbsolutePath?> {
        let resolveBookmark = { AbsolutePath(bookmarkData: bookmark) }
        guard let path = resolveBookmark() else { return Property(nil) }
        
        let m = MutableProperty(resolveBookmark())
        
        var monitor: FileMonitor? = FileMonitor(path: path, events: [.rename, .delete])
        monitor?.handler = { [weak m] _ in
            guard let resolved = resolveBookmark() else { return nil }
            m?.value = resolved
            // return the new path to indicate we want to start watching the new path
            return resolved
        }
        
        m.addCleanupDisposable(ActionDisposable {
            monitor = nil
        })
        
        return m
    }
}

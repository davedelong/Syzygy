//
//  NSWorkspace.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)

private let workspaceRunningApps: Property<Array<NSRunningApplication>> = NSWorkspace.shared.observe(keyPath: "runningApplications", initialValue: [])

private let workspaceMountedVolumes: Property<Array<AbsolutePath>> = {
    let provider = { () -> Array<AbsolutePath> in
        let urls = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: [.skipHiddenVolumes]) ?? []
        return urls.map { AbsolutePath($0) }
    }
    
    let m = MutableProperty(provider())
    let observer: (Notification) -> Void = { [weak m] _ in
        m?.value = provider()
    }
    
    let names = [NSWorkspace.didMountNotification, NSWorkspace.didRenameVolumeNotification, NSWorkspace.didUnmountNotification]
    let tokens = names.map { NotificationCenter.default.addObserver(forName: $0, object: NSWorkspace.shared, queue: .main, using: observer) }
    
    m.addCleanupDisposable(ActionDisposable {
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
    })
    
    return m
}()

public extension NSWorkspace {
    
    public var runningApps: Property<Array<NSRunningApplication>> { return workspaceRunningApps }
    public var mountedVolumes: Property<Array<AbsolutePath>> { return workspaceMountedVolumes }
    
}

#endif

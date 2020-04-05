//
//  MoveToApplicationsFolder.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

import Foundation
import Security
import ObjCBridge

private struct MoveStrings {
    static let couldNotMove = "Could not move to Applications folder"
    static let questionTitle = "Move to Applications folder?"
    static let questionTitleHome = "Move to Applications folder in your Home folder?"
    static let questionMessage = "I can move myself to the Applications folder if you'd like."
    static let buttonMove = "Move to Applications Folder"
    static let buttonStay = "Do Not Move"
    static let infoNeedsPassword = "Note that this will require an administrator password."
    static let infoInDownloads = "This will keep your Downloads folder uncluttered."
}

private let AlertSuppressKey = "moveToApplicationsFolderAlertSuppress"

public func MoveToApplicationsFolder() {
    if Thread.isMainThread == false {
        DispatchQueue.main.async { MoveToApplicationsFolder() }
        return
    }
    
    if UserDefaults.standard.bool(forKey: AlertSuppressKey) == true { return }
    
    let mainBundleURL = Bundle.main.bundleURL
    
    // Check if the bundle is embedded in another application
    let isNestedApplication = IsApplicationAtURLNested(mainBundleURL)
    
    // Skip if the application is already in some Applications folder,
    // unless it's inside another app's bundle.
    if IsInApplicationsFolder(mainBundleURL) && isNestedApplication == false { return }
    
    let fm = FileManager.default
    
    // Are we on a disk image?
    let diskImageDevice = ContainingDiskImageDevice(mainBundleURL)
    
    let (maybeAppsFolder, isUserApps) = PreferredInstallLocation()
    guard let appsFolder = maybeAppsFolder else { return }
    let destination = appsFolder.appendingPathComponent(mainBundleURL.lastPathComponent)
    
    // Check if we need admin password to write to the Applications directory
    var needsAuthorization = fm.isWritableFile(atPath: appsFolder.path) == false
    
    // Check if the destination bundle is already there but not writable
    needsAuthorization = needsAuthorization || (fm.fileExists(atPath: destination.path) && fm.isWritableFile(atPath: destination.path) == false)
    
    let alert = NSAlert()
    alert.messageText = isUserApps ? MoveStrings.questionTitleHome : MoveStrings.questionTitle
    
    var informativeText = MoveStrings.questionMessage
    if needsAuthorization {
        informativeText += " \(MoveStrings.infoNeedsPassword)"
    } else if IsInDownloadsFolder(mainBundleURL) {
        informativeText += " \(MoveStrings.infoInDownloads)"
    }
    alert.informativeText = informativeText
    alert.addButton(withTitle: MoveStrings.buttonMove)
    
    let cancel = alert.addButton(withTitle: MoveStrings.buttonStay)
    cancel.keyEquivalent = "\u{1b}"
    
    alert.showsSuppressionButton = true
    
    if NSApp.isActive == false {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    let result = alert.runModal()
    guard result == .alertFirstButtonReturn else {
        if alert.suppressionButton?.state == .on {
            UserDefaults.standard.set(true, forKey: AlertSuppressKey)
        }
        return
    }
    
        
    let didntWork = {
        let a = NSAlert()
        a.messageText = MoveStrings.couldNotMove
        a.runModal()
    }
    
    if needsAuthorization {
        var cancelled = false
        if AuthorizedInstall(mainBundleURL, destination, &cancelled) == false {
            if cancelled { return }
            return didntWork()
        }
    } else {
        if fm.fileExists(atPath: destination.path) {
            if let alreadyRunning = RunningApplicationForPath(destination) {
                alreadyRunning.activate()
                exit(0)
            } else if Trash(appsFolder.appendingPathComponent(mainBundleURL.lastPathComponent)) == false {
                return didntWork()
            }
        }
        
        if CopyBundle(mainBundleURL, destination) == false {
            return didntWork()
        }
    }
    
    Relaunch(destination)
    
    if let diskImage = diskImageDevice, isNestedApplication == false {
        let script = "/bin/sleep 5 && /usr/bin/hdiutil detach \(Quote(diskImage)) &"
        Process.launchedProcess(launchPath: "/bin/sh", arguments: ["-c", script])
    }
    
    exit(0)
}

fileprivate func PreferredInstallLocation() -> (URL?, Bool) {
    var appDir: URL?
    var isUserDir = false
    
    let fm = FileManager.default
    let userAppDirs = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
    if let userDir = userAppDirs.first {
        if fm.folderExists(atPath: userDir) {
            let contents = (try? fm.contentsOfDirectory(atPath: userDir)) ?? []
            if contents.contains(where: { $0.hasSuffix(".app") }) {
                appDir = URL(fileURLWithPath: userDir)
                isUserDir = true
            }
        }
    }
    
    if appDir == nil {
        let localLocations = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .localDomainMask, true)
        if let last = localLocations.last {
            appDir = URL(fileURLWithPath: last)
        }
    }
    
    return (appDir, isUserDir)
}

func IsInFolder(_ path: URL, _ folder: FileManager.SearchPathDirectory, _ alternativeName: String? = nil) -> Bool {
    let allFolders = NSSearchPathForDirectoriesInDomains(folder, .allDomainsMask, true)
    for folder in allFolders {
        let u = URL(fileURLWithPath: folder)
        if u.contains(path) { return true }
    }
    
    if let alt = alternativeName {
        let components = (path.path as NSString).pathComponents
        return components.contains(alt)
    }
    
    return false
}

func IsInApplicationsFolder(_ current: URL) -> Bool {
    return IsInFolder(current, .applicationDirectory, "Applications")
}

func IsInDownloadsFolder(_ current: URL) -> Bool {
    return IsInFolder(current, .downloadsDirectory)
}

func RunningApplicationForPath(_ bundlePath: URL) -> NSRunningApplication? {
    let runningApps = NSWorkspace.shared.runningApplications
    for app in runningApps {
        if app.bundleURL == bundlePath { return app }
    }
    return nil
}

func IsApplicationAtURLNested(_ path: URL) -> Bool {
    let components = (path.path as NSString).pathComponents.dropLast()
    
    for c in components {
        if c.hasSuffix(".app") { return true }
    }
    return false
}

func ContainingDiskImageDevice(_ path: URL) -> String? {
    let folder = path.deletingLastPathComponent()
    var statInfo = statfs()
    let nsPath = folder.path as NSString
    guard statfs(nsPath.fileSystemRepresentation, &statInfo) == 0 else { return nil }
    if Int32(statInfo.f_flags) & MNT_ROOTFS == MNT_ROOTFS { return nil }
    
    let device = withUnsafePointer(to: &statInfo.f_mntfromname.0) { (ptr: UnsafePointer<Int8>) -> String in
        let ns = NSString(bytes: ptr, length: strlen(ptr), encoding: String.Encoding.utf8.rawValue) ?? ""
        return ns as String
    }
    
    let hdiutil = Process.runSynchronously(AbsolutePath(fileSystemPath: "/usr/bin/hdiutil"), arguments: ["info", "-plist"], usingPipe: true).success
    
    guard let hdiutilData = hdiutil else { return nil }
    guard let plist = try? Plist(data: hdiutilData) else { return nil }
    let images = plist["images"]
    
    for imagePlist in images.array ?? [] {
        let systemEntities = imagePlist["system-entities"]
        for entity in systemEntities.array ?? [] {
            let entry = entity["dev-entry"]
            if entry.string == device { return entry.string }
        }
    }
    
    return nil
}

func Trash(_ path: URL) -> Bool {
    var ok = false
    do {
        try FileManager.default.trashItem(at: path, resultingItemURL: nil)
        ok = true
    } catch _ { }
    
    if !ok {
        let s = DispatchSemaphore(value: 0)
        NSWorkspace.shared.recycle([path], completionHandler: { (urls, error) in
            ok = error == nil
            s.signal()
        })
        s.wait()
    }
    
    if !ok {
        let scpt = """
set theFile to POSIX file "\(path.path)\"
tell application "Finder"
    move theFile to trash
end tell
"""
        let applescript = NSAppleScript(source: scpt)
        let result = applescript?.executeAndReturnError(nil)
        ok = result != nil
    }
    
    return ok
}

func DeleteOrTrash(_ path: URL) -> Bool {
    do {
        try FileManager.default.removeItem(at: path)
        return true
    } catch _ {
        return Trash(path)
    }
}

func AuthorizedInstall(_ src: URL, _ dst: URL, _ cancelled: inout Bool) -> Bool {
    cancelled = false
    if dst.pathExtension != "app" { return false }
    
    let maybeAuth: Authorization! = Authorization()
    guard let auth = maybeAuth else { return false }
    
    guard auth.execute("/bim/rm", arguments: ["-rf", dst.path]) else { return false }
    guard auth.execute("/bin/cp", arguments: ["-pR", src.path, dst.path]) else { return false }
    return true
}

func CopyBundle(_ src: URL, _ dst: URL) -> Bool {
    do {
        try FileManager.default.copyItem(at: src, to: dst)
        return true
    } catch _ {
        return false
    }
}

func Quote(_ s: String) -> String {
    let r = s.replacingOccurrences(of: "'", with: "'\\''")
    return "'\(r)'"
}

func Relaunch(_ path: URL) {
    let pid = ProcessInfo.processInfo.processIdentifier
    
    let dstPath = Quote(path.path)
    let script = "(while /bin/kill -0 \(pid) >&/dev/null; do /bin/sleep 0.1; done; /usr/bin/xattr -d -r com.apple.quarantine \(dstPath); /usr/bin/open \(dstPath)) &"
    
    Process.launchedProcess(launchPath: "/bin/sh", arguments: ["-c", script])
}

#endif

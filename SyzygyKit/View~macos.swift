//
//  View~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public typealias PlatformView = NSView
public typealias PlatformNib = NSNib
public typealias PlatformWindow = NSWindow
public typealias PlatformViewController = NSViewController
public typealias PlatformLayoutConstraintPriority = NSLayoutConstraint.Priority
public typealias PlatformLayoutGuide = NSLayoutGuide

public extension PlatformNib {
    
    public func instantiate(withOwner ownerOrNil: Any?, options optionsOrNil: [AnyHashable : Any]? = nil) -> [Any] {
        var topLevelObjects: NSArray?
        let ok = self.instantiate(withOwner: ownerOrNil, topLevelObjects: &topLevelObjects)
        
        guard ok == true else { return [] }
        let typedObjects = topLevelObjects as? Array<Any>
        return typedObjects ?? []
    }
    
}

extension PlatformNib: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> PlatformNib? {
        return PlatformNib(nibNamed: name, bundle: bundle)
    }
}

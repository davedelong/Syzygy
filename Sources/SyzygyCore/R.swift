//
//  R.swift
//  Heathen
//
//  Created by Dave DeLong on 8/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//
import Core

public protocol BundleResourceLoadable {
    associatedtype LoadedResourceType
    static func loadResource(name: String, in bundle: Bundle?) -> LoadedResourceType?
}

@dynamicMemberLookup
public struct R<T: BundleResourceLoadable> {
    
    public init() { }
    
    public subscript(dynamicMember member: String) -> T.LoadedResourceType {
        return loadResource(name: member)
    }
    
    // An explicit subscript is nice for when you have to specify an extension
    // Ex: R.images["background.jpg"]
    public subscript(key: String) -> T.LoadedResourceType {
        return loadResource(name: key)
    }
    
    private func loadResource(name: String) -> T.LoadedResourceType {
        let bundles = Bundle.allBundles
        for b in bundles {
            if let r = T.loadResource(name: name, in: b) { return r }
        }
        Abort.because("LoadableResource of type \(T.self) did not find a resource named '\(name)'")
    }
    
}

extension String: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> String? {
        guard let u = bundle?.url(forResource: name, withExtension: "txt") else { return nil }
        guard let s = try? String(contentsOf: u.absoluteURL) else { return nil }
        return s
    }
}

public extension R where T == String {
    static let strings = R<String>()
}

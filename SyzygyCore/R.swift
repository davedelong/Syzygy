//
//  R.swift
//  Heathen
//
//  Created by Dave DeLong on 8/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public protocol BundleResourceLoadable {
    associatedtype LoadedResourceType
    static func loadResource(name: String, in bundle: Bundle?) -> LoadedResourceType?
}

@dynamicMemberLookup
public struct R<T: BundleResourceLoadable> {
    
    public init() { }
    
    public subscript(dynamicMember member: String) -> T.LoadedResourceType {
        guard let r = T.loadResource(name: member, in: .main) else {
            Abort.because("LoadableResource of type \(T.self) did not find a resource named '\(member)'")
        }
        return r
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
    public static let strings = R<String>()
}

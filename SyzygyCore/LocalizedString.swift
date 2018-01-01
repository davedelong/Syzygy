//
//  LocalizedString.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public final class LocalizedString: Hashable {
    
    public enum Provider {
        case raw(String)
        case infoPlist(key: String, bundle: Bundle, missingValue: String)
        case table(key: String, table: String?, bundle: Bundle?, missingValue: String?)
        case custom(() -> String)
        
        internal func provideString() -> String {
            switch self {
                case .raw(let s): return s
                case .infoPlist(key: let k, bundle: let b, missingValue: let v):
                    return (b.object(forInfoDictionaryKey: k) as? String) ?? v
                case .table(key: let k, table: let t, bundle: let b, missingValue: let m):
                    let bundle = b ?? .main
                    return bundle.localizedString(forKey: k, value: m, table: t)
                case .custom(let block):
                    return block()
            }
        }
    }
    
    public static func ==(lhs: LocalizedString, rhs: LocalizedString) -> Bool {
        switch (lhs.provider, rhs.provider) {
            case (.raw(let l), .raw(let r)): return l == r
            case (.infoPlist(let lK, let lB, let lV), .infoPlist(let rK, let rB, let rV)):
                return lB == rB && lK == rK && lV == rV
            case (.table(let lK, let lT, let lB, let lM), .table(let rK, let rT, let rB, let rM)):
                let lBundle = lB ?? .main
                let rBundle = rB ?? .main
                let lTable = lT ?? "Localizable"
                let rTable = rT ?? "Localizable"
                return lBundle == rBundle && lTable == rTable && lK == rK && lM == rM
            default: return false
        }
    }
    
    private let providerLock = NSLock()
    private let provider: Provider
    
    public lazy var value: String = {
        self.providerLock.lock()
        let s = self.provider.provideString()
        self.providerLock.unlock()
        return s
    }()
    public var hashValue: Int { return value.hashValue }
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public convenience init(rawString: String) {
        self.init(provider: .raw(rawString))
    }
    
    public convenience init(key: String, table: String? = nil, bundle: Bundle? = nil, missingValue: String? = nil) {
        self.init(provider: .table(key: key, table: table, bundle: bundle, missingValue: missingValue))
    }
    
    public convenience init(_ block: @escaping () -> String) {
        self.init(provider: .custom(block))
    }
    
    public convenience init(infoKey: String, from bundle: Bundle, missingValue: String) {
        self.init(provider: .infoPlist(key: infoKey, bundle: bundle, missingValue: missingValue))
    }
    
}

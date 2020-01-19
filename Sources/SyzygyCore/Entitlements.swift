//
//  Entitlements.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/10/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import Structures
import Syzygy_ObjC

public struct Entitlements {
    #if BUILDING_FOR_MAC
    internal static let APSKey = "com.apple.developer.aps-environment"
    #elseif BUILDING_FOR_MOBILE
    internal static let APSKey = "aps-environment"
    #endif
    
    public enum APSEnvironment: String {
        case development
        case production
    }
    
    public static let current = Entitlements()
    
    public let raw: Plist
    
    public let applicationIdentifier: String
    
    public let sharedGroupContainers: Array<String>
    public let keychainAccessGroups: Array<String>
    public let associatedDomains: Array<String>
    
    public let iCloudContainerIdentifiers: Array<String>
    public let iCloudDocumentContainers: Array<String>
    public let iCloudKeyValueStoreIdentifiers: Array<String>
    
    public let apsEnvironment: APSEnvironment?
    
    public let inAppPaymentMerchentIdentifiers: Array<String>
    public let passTypeIdentifiers: Array<String>
    public let suppressesPassPresentation: Bool
    public let allowsPaymentPassConfiguration: Bool
    
    fileprivate init?(plist: Plist = Bundle.main.entitlementsPlist) {
        guard plist.isDictionary else { return nil }
        raw = plist
        
        applicationIdentifier = raw.value(for: "application-identifier") ?? "UNKNOWN"
        //!! "Missing application identifier"
        
        sharedGroupContainers = raw.value(for: "com.apple.security.application-groups") ?? []
        keychainAccessGroups = raw.value(for: "keychain-access-groups") ?? []
        associatedDomains = raw.value(for: "com.apple.developer.associated-domains") ?? []
        
        iCloudContainerIdentifiers = raw.value(for: "com.apple.developer.icloud-container-identifiers") ?? []
        iCloudDocumentContainers = raw.value(for: "com.apple.developer.ubiquity-container-identifiers") ?? []
        iCloudKeyValueStoreIdentifiers = raw.value(for: "com.apple.developer.ubiquity-kvstore-identifier") ?? []
        
        if let env: String = raw.value(for: Entitlements.APSKey) {
            apsEnvironment = APSEnvironment(rawValue: env)
        } else {
            apsEnvironment = nil
        }
        
        inAppPaymentMerchentIdentifiers = raw.value(for: "com.apple.developer.in-app-payments") ?? []
        passTypeIdentifiers = raw.value(for: "com.apple.developer.pass-type-identifiers") ?? []
        suppressesPassPresentation = raw.value(for: "com.apple.developer.passkit.pass-presentation-suppression") ?? false
        allowsPaymentPassConfiguration = raw.value(for: "com.apple.developer.payment-pass-provisioning") ?? false
    }
}

extension Bundle {
    
    public var entitlementsPlist: Plist {
        guard self === Bundle.main else { return .unknown }
        guard let data = EntitlementsData() else { return .unknown }
        return (try? Plist(data: data)) ?? .unknown
    }
    
    public var entitlements: Entitlements? {
        return Entitlements(plist: entitlementsPlist)
    }
    
}

//
//  Entitlements.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/10/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Entitlements {
    
    public enum APSEnvironment: String {
        case development
        case production
    }
    
    public enum SandboxAccess {
        case none
        case readOnly
        case readWrite
        
        fileprivate init(plist: Plist, _ base: String) {
            let read = base + ".read-only"
            let write = base + ".read-write"
            if let canRead: Bool = plist.value(for: read), canRead == true {
                self = .readOnly
            } else if let canWrite: Bool = plist.value(for: write), canWrite == true {
                self = .readWrite
            } else {
                self = .none
            }
        }
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
    
    private init?(plist: Plist = Bundle.main.entitlementsPlist) {
        guard plist.isDictionary else { return nil }
        raw = plist
        
        applicationIdentifier = raw.value(for: "application-identifier") !! "Missing application identifier"
        
        sharedGroupContainers = raw.value(for: "com.apple.security.application-groups") ?? []
        keychainAccessGroups = raw.value(for: "keychain-access-groups") ?? []
        associatedDomains = raw.value(for: "com.apple.developer.associated-domains") ?? []
        
        iCloudContainerIdentifiers = raw.value(for: "com.apple.developer.icloud-container-identifiers") ?? []
        iCloudDocumentContainers = raw.value(for: "com.apple.developer.ubiquity-container-identifiers") ?? []
        iCloudKeyValueStoreIdentifiers = raw.value(for: "com.apple.developer.ubiquity-kvstore-identifier") ?? []
        
        #if os(macOS)
        let apsKey = "com.apple.developer.aps-environment"
        #else
        let apsKey = "aps-environment"
        #endif
        
        if let env: String = raw.value(for: apsKey) {
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

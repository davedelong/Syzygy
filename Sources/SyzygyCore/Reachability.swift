//
//  Reachability.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import SystemConfiguration
import Properties

public final class Reachability {
    private let mutableReachable: MutableProperty<Bool>
    public var reachable: Property<Bool> { return mutableReachable }
    
    private let ref: SCNetworkReachability
    
    public init?(host: String) {
        guard host.contains("://") == false else {
            fatalError("Reachability only wants the host. Including the scheme will cause it to not work")
        }
        
        let nsHost = host as NSString
        
        guard let ref = SCNetworkReachabilityCreateWithName(nil, nsHost.utf8String!) else { return nil }
        guard SCNetworkReachabilitySetDispatchQueue(ref, DispatchQueue.main) else { return nil }
        
        self.ref = ref
        
        let isReachable = ref.isReachable
        self.mutableReachable = MutableProperty(isReachable)
        
        startNotifier()
    }
    
    deinit {
        endNotifier()
    }
    
    private func startNotifier() {
        var context = SCNetworkReachabilityContext()
        context.info = Unmanaged.passRetained(self).toOpaque()
        
        let callback: SCNetworkReachabilityCallBack = reachabilityCallback as SCNetworkReachabilityCallBack
        SCNetworkReachabilitySetCallback(ref, callback, &context)
    }
    
    private func endNotifier() {
        SCNetworkReachabilitySetCallback(ref, nil, nil)
    }
    
    fileprivate func reachabilityChanged(_ flags: SCNetworkReachabilityFlags) {
        mutableReachable.value = ref.isReachable(with: flags)
    }
    
}

private extension SCNetworkReachability {
    
    var flags: SCNetworkReachabilityFlags {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self, &flags)
        return flags
    }
    
    var isReachable: Bool {
        return self.isReachable(with: flags)
    }
    
    func isReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        guard flags.isEmpty == false else { return false }
        guard flags.contains(.reachable) else { return false }
        if flags.contains(.connectionRequired) { return false }
        
        return true
    }
    
}

internal func reachabilityCallback(ref: SCNetworkReachability, flags: SCNetworkReachabilityFlags, context: UnsafeMutableRawPointer?) -> Void {
    guard let context = context else { return }
    let reachability = Unmanaged<Reachability>.fromOpaque(context).takeUnretainedValue()
    
    DispatchQueue.main.async {
        reachability.reachabilityChanged(flags)
    }
}

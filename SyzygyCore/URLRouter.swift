//
//  URLRouter.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public final class URLRouter {
    
    public static let shared = URLRouter()
    
    #if os(macOS)
    private let receiver = URLReceiver()
    #endif
    
    private var routers = Array<URLRouting>()
    
    private init() { }
    
    private func handle(urlComponents: URLComponents) -> Bool {
        for router in routers {
            if router.performRouting(for: urlComponents) { return true }
        }
        return false
    }
    
    public func route(url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return false }
        return route(urlComponents: components)
    }
    
    public func route(urlComponents: URLComponents) -> Bool {
        guard Thread.isMainThread else { fatalError("URLs can only be routed on the main thread") }
        
        var components = urlComponents
        if handle(urlComponents: components) { return true }
        
        let path = urlComponents.absolutePath
        if urlComponents.host?.isEmpty == true && path.components.count > 1 {
            guard let firstItem = path.components.first?.itemString else { return false }
            var copy = urlComponents
            copy.host = firstItem // ex: in "/prefs/xcode" , this is the "prefs" bit
            copy.absolutePath = path.deletingFirstComponent()
            components = copy
        }
        
        if handle(urlComponents: components) { return true }
        
        return false
    }
    
    public func addRouter(_ router: URLRouting) {
        guard Thread.isMainThread else { fatalError("Routers can only by mutated on the main thread") }
        routers.append(router)
    }
    
    public func removeRouter(_ router: URLRouting) {
        guard Thread.isMainThread else { fatalError("Routers can only by mutated on the main thread") }
        routers = routers.filter { $0 !== router }
    }
    
}

#if os(macOS)
private class URLReceiver: NSObject {
    
    override init() {
        super.init()
        let manager = NSAppleEventManager.shared()
        manager.setEventHandler(self, andSelector: #selector(URLReceiver.handleURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    @objc func handleURLEvent(_ descriptor: NSAppleEventDescriptor, withReplyEvent reply: NSAppleEventDescriptor) {
        
        let paramDescriptor = descriptor.paramDescriptor(forKeyword: keyDirectObject)
        guard let string = paramDescriptor?.stringValue else { return }
        guard let components = URLComponents(string: string) else { return }
        
        _ = URLRouter.shared.route(urlComponents: components)
    }
    
}
#endif

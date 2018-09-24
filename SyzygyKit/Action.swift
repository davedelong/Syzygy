//
//  Action.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/26/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class Action {
    #if BUILDING_FOR_MAC
    private static let copySelector = #selector(NSText.copy(_:))
    private static let pasteSelector = #selector(NSText.paste(_:))
    #else
    private static let copySelector = #selector(UIResponderStandardEditActions.copy(_:))
    private static let pasteSelector = #selector(UIResponderStandardEditActions.paste(_:))
    #endif
    
    public typealias Handler = (Any?) -> Void
    
    public static func copy(_ handler: @escaping Handler) -> Action {
        return Action(name: "Copy", image: nil, selector: copySelector, handler: handler)
    }
    
    public static func paste(_ handler: @escaping Handler) -> Action {
        return Action(name: "Paste", image: nil, selector: pasteSelector, handler: handler)
    }
    
    public let name: String
    public let image: PlatformImage?
    public let selector: Selector
    public let handler: Handler
    
    public let isStandardEditAction: Bool
    
    private init(name: String, image: PlatformImage? = nil, selector: Selector, handler: @escaping Handler) {
        self.selector = selector
        self.isStandardEditAction = true
        self.name = name
        self.image = image
        self.handler = handler
    }
    
    public init(name: String, image: PlatformImage? = nil, handler: @escaping (Any?) -> Void) {
        self.selector = NSSelectorFromString("perform\(name):")
        self.isStandardEditAction = false
        self.name = name
        self.image = image
        self.handler = handler
    }
    
}

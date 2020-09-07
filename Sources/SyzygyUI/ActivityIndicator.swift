//
//  File.swift
//  
//
//  Created by Dave DeLong on 8/29/20.
//

import SwiftUI

#if os(macOS)

public struct ActivityIndicator: NSViewRepresentable {
    
    public let style: NSProgressIndicator.Style
    
    public init(style: NSProgressIndicator.Style = .spinning) {
        self.style = style
    }

    /// Creates a `NSView` instance to be presented.
    public func makeNSView(context: Self.Context) -> NSProgressIndicator {
        let v = NSProgressIndicator()
        v.isIndeterminate = true
        v.usesThreadedAnimation = true
        return v
    }

    /// Updates the presented `NSView` (and coordinator) to the latest
    /// configuration.
    public func updateNSView(_ nsView: NSProgressIndicator, context: Self.Context) {
        nsView.style = style
        nsView.startAnimation(nil)
    }
    
    public static func dismantleUIView(_ nsView: NSProgressIndicator, coordinator: Void) {
        nsView.stopAnimation(nil)
    }
    
}

#else

public struct ActivityIndicator: UIViewRepresentable {
    
    public let style: UIActivityIndicatorView.Style
    
    public init(style: UIActivityIndicatorView.Style = .medium) {
        self.style = style
    }

    /// Creates a `UIView` instance to be presented.
    public func makeUIView(context: Self.Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Self.Context) {
        uiView.style = style
        uiView.startAnimating()
    }
    
    public static func dismantleUIView(_ uiView: UIActivityIndicatorView, coordinator: Void) {
        uiView.stopAnimating()
    }
    
}

#endif

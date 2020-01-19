//
//  SyzygyView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

open class SyzygyView: PlatformView {
    
    public internal(set) weak var controller: _SyzygyViewControllerBase?
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        wantsLayer = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        wantsLayer = true
    }
    
    open override var wantsLayer: Bool {
        get { return true }
        set { super.wantsLayer = true }
    }
    override open var wantsUpdateLayer: Bool { return true }
    
    private var _needsToUpdateBackgroundColor = false
    private var _bgColor: NSColor?
    public var backgroundColor: NSColor? {
        get { return _bgColor }
        set {
            if newValue != _bgColor {
                _bgColor = newValue
                _needsToUpdateBackgroundColor = true
                setNeedsDisplay(bounds)
            }
        }
    }
    
    override open func updateLayer() {
        if _needsToUpdateBackgroundColor {
            layer?.backgroundColor = backgroundColor?.cgColor
            _needsToUpdateBackgroundColor = false
        }
    }
    
}

#endif

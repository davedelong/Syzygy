//
//  SyzygyView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

open class SyzygyView: NSView {
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layerContentsRedrawPolicy = .onSetNeedsDisplay
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        layerContentsRedrawPolicy = .onSetNeedsDisplay
    }
    
    public internal(set) weak var controller: SyzygyViewController?
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
    
    override open func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        controller?.viewDidMoveToSuperview(self.superview)
    }
    
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        controller?.viewDidMoveToWindow(self.window)
    }
    
}

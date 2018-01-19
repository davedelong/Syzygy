//
//  NSTextField.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)

public extension NSTextField {
    
    public convenience init(label: String, size: NSControl.ControlSize = .regular) {
        self.init(frame: NSRect(x: 0, y: 0, width: 100, height: 22))
        controlSize = size
        setContentCompressionResistancePriority(.required, for: .horizontal)
        isEditable = false
        stringValue = label
        drawsBackground = false
        font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: size))
        cell?.isBezeled = false
        cell?.truncatesLastVisibleLine = false
        usesSingleLineMode = true
        invalidateIntrinsicContentSize()
    }
    
    public convenience init(wrappingLabel: NSAttributedString, size: NSControl.ControlSize = .regular) {
        self.init(label: wrappingLabel.string, size: size)
        attributedStringValue = wrappingLabel
        cell?.wraps = true
        cell?.truncatesLastVisibleLine = false
        usesSingleLineMode = false
        invalidateIntrinsicContentSize()
    }
    
}

#endif

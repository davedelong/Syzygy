//
//  AutosizingTextField.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(macOS)

public class AutosizingTextField: NSTextField {
    private var isEditing = false
    
    override public func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        isEditing = true
    }
    
    override public func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        isEditing = false
    }
    
    override public func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        invalidateIntrinsicContentSize()
    }
    
    override public var intrinsicContentSize: NSSize {
        if isEditing {
            if let fieldEditor = window?.fieldEditor(false, for: self), let cellCopy = cell?.copy() as? NSTextFieldCell {
                cellCopy.stringValue = fieldEditor.string
                return cellCopy.cellSize
            }
        }
        return cell?.cellSize ?? .zero
    }
}
    
#endif

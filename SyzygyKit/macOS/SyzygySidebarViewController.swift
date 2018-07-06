//
//  SyzygySidebarViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/28/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Cocoa

public class SyzygySidebarViewController: SyzygyViewController {
    
    private var _sidebar: NSViewController?
    private var _minimumSidebarWidth: CGFloat = 0
    public var sidebarViewController: NSViewController? {
        get { return _sidebar }
        set {
            if let existing = _sidebar {
                existing.viewIfLoaded?.removeFromSuperview()
                existing.removeFromParent()
            }
            _sidebar = newValue
            if let new = _sidebar {
                _ = view
                _minimumSidebarWidth = new.view.fittingSize.width
                embedChild(new, in: sidebarContainer)
            } else {
                _minimumSidebarWidth = 0
            }
        }
    }
    
    private var _content: NSViewController?
    private var _minimumContentWidth: CGFloat = 0
    public var contentViewController: NSViewController? {
        get { return _content }
        set {
            if let existing = _content {
                existing.viewIfLoaded?.removeFromSuperview()
                existing.removeFromParent()
            }
            _content = newValue
            if let new = _content {
                _ = view
                _minimumContentWidth = new.view.fittingSize.width
                embedChild(new, in: contentContainer)
            } else {
                _minimumContentWidth = 0
            }
        }
    }

    @IBOutlet private var sidebarContainer: NSView?
    @IBOutlet private var sidebarWidth: NSLayoutConstraint?
    
    @IBOutlet private var separator: SyzygyView?
    @IBOutlet private var separatorWidth: NSLayoutConstraint?
    
    @IBOutlet private var contentArea: NSView?
    @IBOutlet private var contentContainer: NSView?
    @IBOutlet private var contentLeadingOffset: NSLayoutConstraint?
    
    private var viewWidth: NSLayoutConstraint?
    private var _dragging = false
    
    public init() {
        super.init(ui: .default)
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewWidth = view.widthAnchor.constraint(equalToConstant: view.bounds.width)
        
        let sep = separator !! "Missing outlet"
        sep.backgroundColor = .lightGray
        
        let options: NSTrackingArea.Options = [.activeInKeyWindow, .enabledDuringMouseDrag, .mouseEnteredAndExited, .mouseMoved, .cursorUpdate]
        let trackingArea = NSTrackingArea(rect: view.bounds, options: options, owner: self, userInfo: nil)
        view.addTrackingArea(trackingArea)
    }
    
    override public func mouseEntered(with event: NSEvent) {
        resetCursor(with: event)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        resetCursor(with: event)
    }
    
    override public func mouseExited(with event: NSEvent) {
        resetCursor(with: event)
    }
    
    public override func mouseDown(with event: NSEvent) {
        guard isEventApproximatelyInsideSeparator(event) else { return }
        _dragging = true
        viewWidth?.constant = view.bounds.width
        viewWidth?.isActive = true
        resetCursor(with: event)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        guard _dragging == true else { return }
        let xOffset = view.convert(event.locationInWindow, from: nil).x
        let newWidth = max(_minimumSidebarWidth, xOffset)
        
        if xOffset < _minimumSidebarWidth / 2.0 {
            contentLeadingOffset?.constant = 0
        } else {
            sidebarWidth?.constant = newWidth
            contentLeadingOffset?.constant = newWidth
        }
        resetCursor(with: event)
    }
    
    public override func mouseUp(with event: NSEvent) {
        if contentLeadingOffset?.constant ?? 0 == 0 {
            contentLeadingOffset?.constant = 0
        } else {
            let finalOffset = contentArea?.frame.minX ?? 0
            sidebarWidth?.constant = finalOffset
            contentLeadingOffset?.constant = finalOffset
        }
        viewWidth?.isActive = false
        resetCursor(with: event)
        _dragging = false
    }
    
    public override func cursorUpdate(with event: NSEvent) {
        resetCursor(with: event)
    }
    
    private func isEventApproximatelyInsideSeparator(_ event: NSEvent) -> Bool {
        let sep = separator !! "Missing separator outlet"
        var sepFrameInView = view.convert(sep.frame, from: sep)
        sepFrameInView = sepFrameInView.insetBy(dx: -3, dy: 0)
        
        let locationInView = view.convert(event.locationInWindow, from: nil)
        return sepFrameInView.contains(locationInView)
    }
    
    private func resetCursor(with event: NSEvent) {
        var cursor: NSCursor = .arrow
        if isEventApproximatelyInsideSeparator(event) || NSEvent.pressedMouseButtons == 1 {
            
            let offset = contentLeadingOffset !! "Missing constraint outlet"
            
            if offset.constant <= _minimumSidebarWidth {
                cursor = .resizeRight
            } else if contentContainer?.frame.width ?? 0 <= _minimumContentWidth {
                cursor = .resizeLeft
            } else {
                cursor = .resizeLeftRight
            }
        }
        cursor.set()
    }
    
    @IBAction public func toggleSidebar(_ sender: Any) {
        let contentOffset = contentLeadingOffset?.constant ?? 0
        if contentOffset == 0 {
            contentLeadingOffset?.constant = sidebarWidth?.constant ?? 0
        } else {
            contentLeadingOffset?.constant = 0
        }
    }
    
}

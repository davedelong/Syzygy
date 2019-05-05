//
//  NSWindow.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//
    
public extension NSWindow {
    
    var allGestureRecognizers: Array<NSGestureRecognizer> {
        let mutable = NSMutableArray()
        
        let remainingViews = NSMutableArray()
        if let content = self.contentView {
            remainingViews.add(content)
        }
        
        while let first = remainingViews.firstObject {
            remainingViews.removeObject(at: 0)
            if let firstView = first as? NSView {
                mutable.add(firstView)
                remainingViews.addObjects(from: firstView.subviews)
            }
        }
        
        let views = mutable as! Array<NSView>
        return views.flatMap { $0.gestureRecognizers }
    }
    
    func gestureRecognizersIntersecting(_ view: NSView) -> Array<NSGestureRecognizer> {
        guard view.window == self else { return [] }
        let allRecognizers = allGestureRecognizers
        
        let recognizersAndWindowRects = allRecognizers.map { gr -> (NSGestureRecognizer, NSRect) in
            let windowFrame = gr.view?.convert(gr.view?.bounds ?? .zero, to: nil) ?? .zero
            return (gr, windowFrame)
        }
        
        let viewFrame = view.convert(view.bounds, to: nil)
        return recognizersAndWindowRects.compactMap { (gr, f) -> NSGestureRecognizer? in
            return f.intersects(viewFrame) ? gr : nil
        }
    }
    
    func convertFromScreen(_ point: NSPoint) -> NSPoint {
        let rect = NSRect(origin: point, size: .zero)
        return convertFromScreen(rect).origin
    }
    
    func convertFromScreen(_ point: NSPoint, to view: NSView) -> NSPoint {
        let pointInWindow = convertFromScreen(point)
        return view.convert(pointInWindow, from: nil)
    }
    
}

extension NSGestureRecognizer {
    
    public func beginVisualizing() {
        guard let view = self.view else { return }
        
        let visualized = VisualizedGRView(frame: view.bounds)
        view.addSubview(visualized)
    }
    
    public func endVisualizing() {
        guard let view = self.view else { return }
        let visualizedViews = view.subviews.compactMap { $0 as? VisualizedGRView }
        visualizedViews.forEach { $0.removeFromSuperview() }
    }
    
}

private class VisualizedGRView: NSView {
    override var wantsLayer: Bool {
        get { return true }
        set { super.wantsLayer = true }
    }
    override func updateLayer() {
        layer?.backgroundColor = NSColor.green.cgColor
    }
}

//
//  NSEvent.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//
    
public extension NSEvent {
    
    public static var mouseMonitor: Property<NSEvent?> = {
        let m = MutableProperty<NSEvent?>(nil)
        let monitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .scrollWheel], handler: { [weak m] event in
            m?.value = event
            return event
        })
        if let monitor = monitor {
            m.addCleanupDisposable(ActionDisposable { NSEvent.removeMonitor(monitor) })
        }
        return m
    }()
    
    public static func mouseMoved(inside view: NSView) -> Property<Bool> {
        return mouseMonitor.map { e in
            guard e != nil else { return false }
            guard let w = view.window else { return false }
            let locationInView = w.convertFromScreen(NSEvent.mouseLocation, to: view)
            return view.bounds.contains(locationInView)
            }.skipRepeats()
    }
}

//
//  SyzygyViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

open class SyzygyViewController: NSViewController {
    
    // Selection
    private let parentWantsSelection = MirroredProperty(false)
    private let wantsSelection = MutableProperty(false)
    public let selectable = MutableProperty(false)
    public let selected: Property<Bool>
    
    // Background Color
    public let defaultBackgroundColor = MutableProperty<NSColor?>(nil)
    public let selectedBackgroundColor = MutableProperty<NSColor?>(NSColor.selectedMenuItemColor)
    public let currentBackgroundColor: Property<NSColor?>
    
    // Gestures
    private var rightClickRecognizer: NSClickGestureRecognizer?
    private var doubleClickRecognizer: NSClickGestureRecognizer?
    
    public let disposable = CompositeDisposable()
    
    public var syzygyView: SyzygyView { return view as! SyzygyView }
    
    // State Management
    private var isBulkModifyingChildren = false
    internal var modalHandler: ((NSApplication.ModalResponse) -> Void)?
    
    // Overrides
    open override var children: Array<NSViewController> {
        get { return super.children }
        set {
            isBulkModifyingChildren = true
            super.children = newValue
            isBulkModifyingChildren = false
        }
    }
    
    public enum UI {
        case empty
        case `default`
        case explicit(NSNib.Name, Bundle)
    }
    
    public init(ui: UI = .default) {
        let actuallySelected = parentWantsSelection.combine(wantsSelection, selectable).map { (parentWants, wants, can) -> Bool in
            return (parentWants || wants) && can
        }
        selected = actuallySelected.skipRepeats()
        
        let bgColor = selected.combine(defaultBackgroundColor, selectedBackgroundColor).map { (isSelected, def, sel) -> NSColor? in
            let color = sel ?? def
            return isSelected ? color : def
        }
        currentBackgroundColor = bgColor.skipRepeats(==)
        
        let nib: NSNib.Name?
        let bundle: Bundle?
        
        switch ui {
            case .empty:
                nib = NSNib.Name("Empty")
                bundle = Bundle(for: SyzygyViewController.self)
            case .default:
                nib = NSNib.Name("\(type(of: self))")
                bundle = Bundle(for: type(of: self))
            case .explicit(let n, let b):
                nib = n
                bundle = b
        }
        super.init(nibName: nib, bundle: bundle)
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func insertChild(_ childViewController: NSViewController, at index: Int) {
        super.insertChild(childViewController, at: index)
        
        if let child = childViewController as? SyzygyViewController {
            if childViewController.parent == self {
                child.parentWantsSelection.takeValue(from: wantsSelection)
            }
        }
    }
    
    open override func removeChild(at index: Int) {
        let child = children[index]
        super.removeChild(at: index)
        
        if let child = child as? SyzygyViewController {
            child.parentWantsSelection.takeValue(from: Property.false)
        }
    }
    
    public func embedChildViewController(_ viewController: NSViewController, in aView: NSView? = nil) {
        let container = (aView?.isEmbeddedIn(view) == true ? aView : view) ?? view
        
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        
        addChild(viewController)
        viewController.view.frame = container.bounds
        viewController.view.autoresizingMask = [.width, .height]
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        container.addSubview(viewController.view)
    }
    
    public func replaceChildViewController(_ child: NSViewController, with newChild: NSViewController, transitionOptions: NSViewController.TransitionOptions = [], in container: NSView? = nil) {
        guard child.parent == self else { Abort.because("The child \(child) is not a direct child of \(self)") }
        let potentialContainer = container ?? child.view.superview
        guard let viewContainer = potentialContainer else { Abort.because("The child's view is not in the UI") }
        guard viewContainer.isEmbeddedIn(view) else { Abort.because("The container view is not in \(self)'s view hierarchy") }
        
        embedChildViewController(newChild, in: viewContainer)
        
        if transitionOptions.isEmpty {
            child.view.removeFromSuperview()
            child.removeFromParent()
        } else {
            transition(from: child, to: newChild, options: transitionOptions, completionHandler: {
                child.view.removeFromSuperview()
                child.removeFromParent()
            })
        }
    }
    
    open func endModalSession(code: NSApplication.ModalResponse) {
        guard let handler = modalHandler else {
            if let p = parent as? SyzygyViewController {
                p.endModalSession(code: code)
            }
            return
        }
        modalHandler = nil
        handler(code)
    }
    
    open override func loadView() {
        super.loadView()
        
        let loadedView = view
        let ddv: SyzygyView
        
        if let v = loadedView as? SyzygyView {
            ddv = v
        } else {
            let newView = SyzygyView(frame: loadedView.frame)
            loadedView.frame = newView.bounds
            loadedView.autoresizingMask = [.width, .height]
            loadedView.translatesAutoresizingMaskIntoConstraints = true
            newView.addSubview(loadedView)
            
            newView.autoresizingMask = [.width, .height]
            newView.translatesAutoresizingMaskIntoConstraints = true
            view = newView
            
            ddv = newView
        }
        if ddv.identifier == nil {
            ddv.identifier = NSUserInterfaceItemIdentifier(rawValue: "\(type(of: self)).SyzygyView.\(ddv)")
        }
        ddv.controller = self
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        disposable += currentBackgroundColor.observe { [weak self] color in
            self?.syzygyView.backgroundColor = color
        }
        
        if overrides(#selector(rightClickAction(_:)), upTo: SyzygyViewController.self) {
            let r = NSClickGestureRecognizer(target: self, action: #selector(SyzygyViewController.rightClickAction(_:)))
            r.numberOfClicksRequired = 1
            r.buttonMask = 0x2
            r.delaysPrimaryMouseButtonEvents = false
            view.addGestureRecognizer(r)
            rightClickRecognizer = r
        }
        
        if overrides(#selector(doubleClickAction(_:)), upTo: SyzygyViewController.self) {
            let d = NSClickGestureRecognizer(target: self, action: #selector(SyzygyViewController.doubleClickAction(_:)))
            d.numberOfClicksRequired = 2
            d.buttonMask = 0x1
            d.delaysPrimaryMouseButtonEvents = false
            view.addGestureRecognizer(d)
            doubleClickRecognizer = d
        }
        
    }
    
    open func select() { wantsSelection.value = true }
    open func deselect() { wantsSelection.value = false }
    public func toggleSelection() {
        //        wantsSelection.modify { s in
        //            print("selected? \(s)")
        //            return !s
        //        }
        wantsSelection.value = !wantsSelection.value
    }
    
    @objc open func rightClickAction(_ sender: Any) { }
    @objc open func doubleClickAction(_ sender: Any) { }
    
    open func viewDidMoveToSuperview(_ superview: NSView?) { }
    
    open func viewDidMoveToWindow(_ window: NSWindow?) { }
    
}

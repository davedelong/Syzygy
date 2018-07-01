//
//  SyzygyViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

open class SyzygyViewController: PlatformViewController {
    
    // Selection
    private let parentWantsSelection = MirroredProperty(false)
    private let wantsSelection = MutableProperty(false)
    public let selectable = MutableProperty(false)
    public let selected: Property<Bool>
    
    // Background Color
    public let defaultBackgroundColor = MutableProperty<PlatformColor?>(nil)
    public let selectedBackgroundColor = MutableProperty<PlatformColor?>(.defaultSelectionColor)
    public let currentBackgroundColor: Property<PlatformColor?>
    
    #if BUILDING_FOR_DESKTOP
    // Gestures
    private var rightClickRecognizer: NSClickGestureRecognizer?
    private var doubleClickRecognizer: NSClickGestureRecognizer?
    #endif
    
    public let disposable = CompositeDisposable()
    
    public var syzygyView: SyzygyView { return view as! SyzygyView }
    
    // State Management
    private var isBulkModifyingChildren = false
    
    public func updateChildren(_ newChildren: Array<PlatformViewController>) {
        isBulkModifyingChildren = true
        
        #if BUILDING_FOR_DESKTOP
        super.children = newChildren
        #else
        let kids = children
        kids.forEach { $0.removeFromParent() }
        newChildren.forEach {
            addChild($0)
            $0.didMove(toParent: self)
        }
        #endif
        
        isBulkModifyingChildren = false
    }
    
    public enum UI {
        case empty
        case `default`
        case explicit(PlatformNib.Name, Bundle)
    }
    
    public init(ui: UI = .default) {
        let actuallySelected = parentWantsSelection.combine(wantsSelection, selectable).map { (parentWants, wants, can) -> Bool in
            return (parentWants || wants) && can
        }
        selected = actuallySelected.skipRepeats()
        
        let bgColor = selected.combine(defaultBackgroundColor, selectedBackgroundColor).map { (isSelected, def, sel) -> PlatformColor? in
            let color = sel ?? def
            return isSelected ? color : def
        }
        currentBackgroundColor = bgColor.skipRepeats(==)
        
        let nib: PlatformNib.Name?
        let bundle: Bundle?
        
        switch ui {
            case .empty:
                nib = PlatformNib.Name("Empty")
                bundle = Bundle(for: SyzygyViewController.self)
            case .default:
                nib = PlatformNib.Name("\(type(of: self))")
                bundle = Bundle(for: type(of: self))
            case .explicit(let n, let b):
                nib = n
                bundle = b
        }
        super.init(nibName: nib, bundle: bundle)
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    #if BUILDING_FOR_DESKTOP
    
    open override func insertChild(_ childViewController: PlatformViewController, at index: Int) {
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
            child.parentWantsSelection.takeValue(from: .false)
        }
    }
    
    #else
    
    open override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        if let child = childController as? SyzygyViewController {
            if childController.parent == self {
                child.parentWantsSelection.takeValue(from: wantsSelection)
            }
        }
    }
    
    open override func removeFromParent() {
        super.removeFromParent()
        parentWantsSelection.takeValue(from: .false)
    }
    
    #endif
    
    public func embedChild(_ viewController: PlatformViewController, in aView: PlatformView? = nil) {
        let container = (aView?.isEmbeddedIn(view) == true ? aView : view!) ?? view!
        
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        
        addChild(viewController)
        viewController.view.frame = container.bounds
        viewController.view.autoresizingMask = [.width, .height]
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        container.addSubview(viewController.view)
    }
    
    #if BUILDING_FOR_DESKTOP
    
    public func replaceChild(_ child: PlatformViewController, with newChild: PlatformViewController, transitionOptions: NSViewController.TransitionOptions = [], in container: PlatformView? = nil) {
        guard child.parent == self else { Abort.because("The child \(child) is not a direct child of \(self)") }
        let potentialContainer = container ?? child.view.superview
        guard let viewContainer = potentialContainer else { Abort.because("The child's view is not in the UI") }
        guard viewContainer.isEmbeddedIn(view) else { Abort.because("The container view is not in \(self)'s view hierarchy") }
        
        embedChild(newChild, in: viewContainer)
        
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
    
    #else
    
    public func replaceChild(_ child: PlatformViewController, with newChild: PlatformViewController, transitionOptions: UIView.AnimationOptions = [], in container: PlatformView? = nil) {
        guard child.parent == self else { Abort.because("The child \(child) is not a direct child of \(self)") }
        let potentialContainer = container ?? child.view.superview
        guard let viewContainer = potentialContainer else { Abort.because("The child's view is not in the UI") }
        guard viewContainer.isEmbeddedIn(view) else { Abort.because("The container view is not in \(self)'s view hierarchy") }
        
        embedChild(newChild, in: viewContainer)
        
        if transitionOptions.isEmpty {
            child.view.removeFromSuperview()
            child.removeFromParent()
        } else {
            newChild.view.alpha = 0.0
            UIView.animate(withDuration: 0.3, delay: 0.0,
                           options: transitionOptions,
                           animations: {
                            child.view.alpha = 0.0
                            newChild.view.alpha = 1.0
            },
                           completion: { _ in
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                            child.view.alpha = 1.0
            })
        }
        
    }
    
    #endif
    
    open override func loadView() {
        super.loadView()
        
        let loadedView = view!
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
        #if BUILDING_FOR_DESKTOP
        if ddv.identifier == nil {
            ddv.identifier = NSUserInterfaceItemIdentifier(rawValue: "\(type(of: self)).SyzygyView.\(ddv)")
        }
        #endif
        ddv.controller = self
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        disposable += currentBackgroundColor.observe { [weak self] color in
            self?.syzygyView.backgroundColor = color
        }
        
        #if BUILDING_FOR_DESKTOP
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
        #endif
        
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
    
    open func viewDidMoveToSuperview(_ superview: PlatformView?) { }
    
    open func viewDidMoveToWindow(_ window: PlatformWindow?) { }
    
}

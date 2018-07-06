//
//  SyzygyViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public extension Abort.Reason {
    public static let notADirectChildViewController = Abort.Reason("View controller is not a direct child")
}

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
    
    // Gestures
    internal var rightClickRecognizer: PlatformClickGestureRecognizer?
    internal var doubleClickRecognizer: PlatformClickGestureRecognizer?
    
    public let disposable = CompositeDisposable()
    
    public var syzygyView: SyzygyView { return view as! SyzygyView }
    
    // State Management
    private var isBulkModifyingChildren = false
    
    public func updateChildren(_ newChildren: Array<PlatformViewController>) {
        isBulkModifyingChildren = true
        _setChildren(newChildren)
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
    
    // overriding this means that the parentWantsSelection logic happens TWICE
    // when adding a child via addChild(_:)
    open override func insertChild(_ childViewController: PlatformViewController, at index: Int) {
        super.insertChild(childViewController, at: index)
        
        if let child = childViewController as? SyzygyViewController {
            if childViewController.parent == self {
                child.parentWantsSelection.takeValue(from: wantsSelection)
            }
        }
    }
    
    // overriding this means that the parentWantsSelection logic happens TWICE
    // when removing a child via removeFromParent()
    open override func removeChild(at index: Int) {
        let child = children[index]
        super.removeChild(at: index)
        
        if let child = child as? SyzygyViewController {
            child.parentWantsSelection.takeValue(from: .false)
        }
    }
    
    open override func addChild(_ childController: PlatformViewController) {
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
    
    public func embedChild(_ viewController: PlatformViewController, in aView: PlatformView? = nil) {
        let container = (aView?.isEmbeddedIn(view) == true ? aView : view) ?? view
        
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        
        addChild(viewController)
        viewController.view.frame = container.bounds
        viewController.view.autoresizingMask = [.width, .height]
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        container.addSubview(viewController.view)
    }
    
    public func replaceChild(_ child: PlatformViewController, with newChild: PlatformViewController, transitionOptions: SyzygyViewController.TransitionOptions = [], in container: PlatformView? = nil) {
        Assert.that(child.parent == self, otherwise: .notADirectChildViewController)
        
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
        ddv.controller = self
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        disposable += currentBackgroundColor.observe { [weak self] color in
            self?.syzygyView.backgroundColor = color
        }
        
        _platformViewDidLoad()
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

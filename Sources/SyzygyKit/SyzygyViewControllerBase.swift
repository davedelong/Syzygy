//
//  SyzygyViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import ObjCBridge

public extension Abort.Reason {
    static func viewController(_ vc: PlatformViewController, mustBeChildOf parent: PlatformViewController) -> Abort.Reason {
        let p = String(describing: vc.parent)
        return Abort.Reason("\(vc) must be a direct child of \(parent), but is actually a child of \(p)")
    }
    static func view(_ view: PlatformView, mustBeInHierarchyOf vc: PlatformViewController) -> Abort.Reason {
        return Abort.Reason("Container view \(view) is not in \(vc)'s view hierarchy")
    }
}


/// _SyzygyViewControllerBase exists because of weirdness in creating cross-platform view controllers
/// and inconsistent view controller API between the two
///
/// On macOS, the "child view controller" primitives are -insertChild:atIndex: and -removeChildAtIndex:
/// On iOS, the primitives are -addChildViewController: and -removeFromParentViewController
///
/// There is no sane way to create a class that only overrides one set on one platform and another set on
/// another platform, all within the same class (at least, not without getting in to runtime shenanigans).
/// Thus, the common logic of both kinds of view controllers is extracted in to this "Base" class,
/// and then the actual "public" classes are platform-specific versions in the ~ios/~macos files,
/// which declare the actual "SyzygyViewController" class.
///
/// DO NOT subclass _SyzygyViewControllerBase yourself.
open class _SyzygyViewControllerBase: PlatformViewController {
    
    private static var nibsAndBundles = Dictionary<ObjectIdentifier, (PlatformNib.Name, Bundle)>()
    
    private static func nibAndBundle(for class: AnyClass) -> (nib: PlatformNib.Name, bundle: Bundle)? {
        var currentClass: AnyClass? = `class`
        
        while let current = currentClass {
            if let cached = nibsAndBundles[ObjectIdentifier(current)] { return cached }
            
            let bundle = Bundle(for: current)
            
            if bundle.path(forResource: "\(current)", ofType: "nib") != nil {
                let value: (PlatformNib.Name, Bundle) = (PlatformNib.Name("\(current)"), bundle)
                nibsAndBundles[ObjectIdentifier(current)] = value
                return value
            }
            
            currentClass = current.superclass()
        }
        
        return nil
    }
    
    // Selection
    internal let parentWantsSelection = MirroredProperty(false)
    internal let wantsSelection = MutableProperty(false)
    public let selectable = MutableProperty(false)
    public let selected: Property<Bool>
    
    // Background Color
    public let defaultBackgroundColor = MutableProperty<PlatformColor?>(.white)
    public let selectedBackgroundColor = MutableProperty<PlatformColor?>(.defaultSelectionColor)
    public let currentBackgroundColor: Property<PlatformColor?>
    
    public let disposable = CompositeDisposable()
    
    private let shouldLoadEmptyView: Bool
    private var _syzygyView: SyzygyView?
    public var syzygyView: SyzygyView? { return _syzygyView }
    
    #if BUILDING_FOR_MOBILE
    private var _preferredStatusBarStyle: UIStatusBarStyle = .default
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return _preferredStatusBarStyle }
        set {
            _preferredStatusBarStyle = newValue
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    #endif
    
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
                nib = nil
                bundle = nil
            case .default:
                let c = type(of: self)
                let nibAndBundle = _SyzygyViewControllerBase.nibAndBundle(for: c)
                nib = nibAndBundle?.nib
                bundle = nibAndBundle?.bundle
            case .explicit(let n, let b):
                nib = n
                bundle = b
        }
        self.shouldLoadEmptyView = (nib != nil)
        super.init(nibName: nib, bundle: bundle)
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func loadView() {
        ViewSwizzling.swizzleInHierarchyHooks()
        
        if shouldLoadEmptyView == true {
            self.view = SyzygyView()
        } else {
            super.loadView()
        }
        
        var ddv: SyzygyView?
        
        if let v = view as? SyzygyView {
            ddv = v
        } else if (view is PlatformTableViewCell) == false {
            let newView = SyzygyView(frame: loadedView.frame)
            newView.embedSubview(loadedView)
            view = newView
            
            ddv = newView
        }
        ddv?.controller = self
        _syzygyView = ddv
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        disposable += syzygyView?.take(\.backgroundColor, from: currentBackgroundColor)
    }
    
    open func select() { wantsSelection.value = true }
    open func deselect() { wantsSelection.value = false }
    public func toggleSelection() {
        // this negates the selection value, because ! is a (Bool) -> Bool function
        wantsSelection.modify(!)
    }
    
    @objc open func viewDidMoveToSuperview(_ superview: PlatformView?) { }
    @objc open func viewDidMoveToWindow(_ window: PlatformWindow?) { }
    
    open func viewSystemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: PlatformLayoutConstraintPriority, verticalFittingPriority: PlatformLayoutConstraintPriority) -> CGSize {
        return targetSize
    }
    
}

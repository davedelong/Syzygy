//
//  View.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import Core

#if BUILDING_FOR_MAC

public typealias PlatformView = NSView
public typealias PlatformNib = NSNib
public typealias PlatformWindow = NSWindow
public typealias PlatformViewController = NSViewController
public typealias PlatformLayoutConstraintPriority = NSLayoutConstraint.Priority
public typealias PlatformLayoutGuide = NSLayoutGuide
public typealias PlatformTableViewCell = NSTableCellView

public extension PlatformNib {
    
    func instantiate(withOwner ownerOrNil: Any?, options optionsOrNil: [AnyHashable : Any]? = nil) -> [Any] {
        var topLevelObjects: NSArray?
        let ok = self.instantiate(withOwner: ownerOrNil, topLevelObjects: &topLevelObjects)
        
        guard ok == true else { return [] }
        let typedObjects = topLevelObjects as? Array<Any>
        return typedObjects ?? []
    }
    
}

extension PlatformNib: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> PlatformNib? {
        return PlatformNib(nibNamed: name, bundle: bundle)
    }
}

#elseif BUILDING_FOR_MOBILE

public typealias PlatformView = UIView
public typealias PlatformNib = UINib
public typealias PlatformWindow = UIWindow
public typealias PlatformViewController = UIViewController
public typealias PlatformLayoutConstraintPriority = UILayoutPriority
public typealias PlatformLayoutGuide = UILayoutGuide
public typealias PlatformTableViewCell = UITableViewCell

public extension UINib {
    typealias Name = String
}

public extension UIView.AutoresizingMask {
    static let width = UIView.AutoresizingMask.flexibleWidth
    static let height = UIView.AutoresizingMask.flexibleHeight
}

extension PlatformNib: BundleResourceLoadable {
    public static func loadResource(name: String, in bundle: Bundle?) -> PlatformNib? {
        return PlatformNib(nibName: name, bundle: bundle)
    }
}

#endif

public extension R where T == PlatformNib {
    static let nib = R<PlatformNib>()
}

public extension NSCoding where Self: PlatformView {
    
    static func make() -> Self {
        let bundle = Bundle(for: self)
        let maybeNib = PlatformNib.loadResource(name: "\(self)", in: bundle)
        let nib = maybeNib !! "Unable to load nib named \(self)"
        
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let matches = objects.compactMap { $0 as? Self }
        
        if let firstMatch = matches.first {
            return firstMatch
        } else {
            return Self.init()
        }
    }
    
}

public extension PlatformView {
    
    static func firstCommonSuperview(_ views: Array<PlatformView>) -> PlatformView? {
        guard views.count >= 2 else { return views.first }
        let first = views[0]
        let remaining = views.dropFirst()
        // we know remaining has at least one element
        var common = Set(remaining[0].superviews)
        common = remaining.dropFirst().reduce(into: common) { $0.formIntersection($1.superviews) }
        return first.superviews.first(where: common.contains)
    }
        
    var platformLayer: CALayer? { return layer }
    
    var superviews: AnySequence<UIView> {
        return AnySequence(sequence(first: self, next: { $0.superview }))
    }
    
    func isEmbeddedIn(_ other: PlatformView) -> Bool {
        var possible: PlatformView? = self
        while let p = possible {
            if p == other { return true }
            possible = p.superview
        }
        return false
    }
    
    func firstCommonSuperview(with otherView: PlatformView) -> PlatformView? {
        let theirSuperviews = Set(otherView.superviews)
        return superviews.first(where: theirSuperviews.contains)
    }
    
    func embedSubview(_ subview: PlatformView, margins: PlatformEdgeInsets = .zero) {
        subview.removeFromSuperview()
        subview.frame = self.bounds
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.top.constraint(equalTo: top, constant: margins.top),
            bottom.constraint(equalTo: subview.bottom, constant: margins.bottom),
            
            subview.leading.constraint(equalTo: leading, constant: margins.left),
            trailing.constraint(equalTo: subview.trailing, constant: margins.right)
        ])
    }
    
    func removeAllSubviews() {
        while let n = subviews.first {
            n.removeFromSuperview()
        }
    }
    
    func firstSubview<T: PlatformView>() -> T? {
        guard let match = subview(where: { $0 is T }, recurses: true) else { return nil }
        return match as? T
    }
    
    func subview(where matches: (PlatformView) -> Bool, recurses: Bool = true) -> PlatformView? {
        for subview in subviews {
            if matches(subview) { return subview }
            if recurses {
                if let match = subview.subview(where: matches, recurses: recurses) { return match }
            }
        }
        return nil
    }
    
}

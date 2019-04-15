//
//  SyzygyStackViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

public class SyzygyStackViewController: UIViewController {
    private lazy var scroller: UIScrollView = {
        let sv = UIScrollView()
        sv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        sv.translatesAutoresizingMaskIntoConstraints = true
        sv.preservesSuperviewLayoutMargins = true
        return sv
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.preservesSuperviewLayoutMargins = true
        sv.axis = .vertical
        return sv
    }()
    
    private lazy var topSpacer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = true
        v.autoresizingMask = [.flexibleWidth]
        return v
    }()
    
    public var spacing: CGFloat {
        get { return stack.spacing }
        set {
            stack.spacing = newValue
            topSpacer.frame.size.height = newValue
        }
    }
    
    public var showsVerticalScrollIndicator: Bool {
        get { return scroller.showsVerticalScrollIndicator }
        set { scroller.showsVerticalScrollIndicator = newValue }
    }
    
    private let scrollsContent: Bool
    private let disposable = CompositeDisposable()
    private let observedChildren: Property<Array<UIViewController>>
    
    public convenience init(children: Array<UIViewController>, scrollsContents: Bool = true) {
        self.init(children: Property(children), scrollContents: scrollsContents)
    }
    
    public init(children: Property<Array<UIViewController>>, scrollContents: Bool = true) {
        self.observedChildren = children
        self.scrollsContent = scrollContents
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) { Abort.because(.notYetImplemented) }
    
    override public func loadView() {
        if scrollsContent == true {
            view = scroller
            scroller.addSubview(stack)
            scroller.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stack]|", options: [], metrics: nil, views: ["stack": stack]))
            scroller.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stack]|", options: [], metrics: nil, views: ["stack": stack]))
            scroller.addConstraint(scroller.width.constraint(equalTo: stack.width))
        } else {
            view = stack
        }
        
        stack.addArrangedSubview(topSpacer)
        disposable += observedChildren.observe { [weak self] kids in
            for kid in kids {
                if kid.parent != self {
                    kid.willMove(toParent: nil)
                    kid.removeFromParent()
                }
                
                self?.addChild(kid)
                kid.willMove(toParent: self)
                
                self?.stack.addArrangedSubview(kid.view)
            }
        }
    }

}

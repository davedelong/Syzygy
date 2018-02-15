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
    private let children: Property<Array<UIViewController>>
    
    public init(children: Property<Array<UIViewController>>, scrollContents: Bool = true) {
        self.children = children
        self.scrollsContent = scrollContents
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) { Die.notImplemented() }
    
    override public func loadView() {
        if scrollsContent == true {
            view = scroller
            scroller.addSubview(stack)
            scroller.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stack]|", options: [], metrics: nil, views: ["stack": stack]))
            scroller.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stack]|", options: [], metrics: nil, views: ["stack": stack]))
            scroller.addConstraint(scroller.widthAnchor.constraint(equalTo: stack.widthAnchor))
        } else {
            view = stack
        }
        
        stack.addArrangedSubview(topSpacer)
        disposable += children.observe { [weak self] kids in
            for kid in kids {
                if kid.parent != self {
                    kid.willMove(toParentViewController: nil)
                    kid.removeFromParentViewController()
                }
                
                self?.addChildViewController(kid)
                kid.willMove(toParentViewController: self)
                
                self?.stack.addArrangedSubview(kid.view)
            }
        }
    }

}

//
//  SyzygyScrollingContentViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/21/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import Foundation

open class SyzygyScrollingContentViewController: SyzygyViewController {
    
    private let scrollView: UIScrollView
    private let scrollViewContentContainer = UIView()
    private let content: PlatformViewController
    
    public init(content: PlatformViewController) {
        scrollView = UIScrollView(frame: .zero)
        self.content = content
        super.init(ui: .empty)
    }
    
    public required init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.embedSubview(scrollView)
        
        scrollView.preservesSuperviewLayoutMargins = true
        
        scrollView.embedSubview(scrollViewContentContainer)
        scrollView.width.constraint(equalTo: scrollViewContentContainer.width).isActive = true
        
        embedChild(content, in: scrollViewContentContainer)
        
    }
    
}

#endif

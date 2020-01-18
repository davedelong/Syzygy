//
//  SyzygyLoadingViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/5/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public class SyzygyLoadingViewController: SyzygyViewController {
    
    #if BUILDING_FOR_MOBILE
    private let loading: UIActivityIndicatorView

    public init(style: UIActivityIndicatorView.Style = .gray) {
        loading = UIActivityIndicatorView(style: style)
        loading.translatesAutoresizingMaskIntoConstraints = false
        super.init(ui: .empty)
    }
    #else
    
    private let loading: NSProgressIndicator
    
    public init(style: NSProgressIndicator.Style = .spinning) {
        loading = NSProgressIndicator(frame: .zero)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.style = style
        super.init(ui: .empty)
    }
    
    #endif
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loading)
        
        let topConstraint: NSLayoutConstraint
        let leadingConstraint: NSLayoutConstraint
        
        
        
        #if BUILDING_FOR_MOBILE
        topConstraint = loading.top.constraint(greaterThanOrEqualToSystemSpacingBelow: view.top)
        leadingConstraint = loading.leading.constraint(greaterThanOrEqualToSystemSpacingAfter: view.leading)
        #else
        topConstraint = loading.top.constraint(greaterThanOrEqualTo: view.top, constant: 8)
        leadingConstraint = loading.leading.constraint(greaterThanOrEqualTo: view.leading, constant: 8)
        #endif
            
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            topConstraint, leadingConstraint
        ])
        
        #if BUILDING_FOR_MOBILE
        loading.startAnimating()
        #else
        loading.startAnimation(self)
        #endif
    }
    
}

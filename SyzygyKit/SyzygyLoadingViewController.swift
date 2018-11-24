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
        topConstraint = loading.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.topAnchor, multiplier: 1.0)
        leadingConstraint = loading.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0)
        #else
        topConstraint = loading.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 8)
        leadingConstraint = loading.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 8)
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

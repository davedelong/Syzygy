//
//  SyzygyLoadingViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/5/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

public class SyzygyLoadingViewController: SyzygyViewController {
    
    private let loading: UIActivityIndicatorView

    public init(style: UIActivityIndicatorView.Style = .gray) {
        loading = UIActivityIndicatorView(style: style)
        loading.translatesAutoresizingMaskIntoConstraints = false
        super.init(ui: .empty)
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loading.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: view.topAnchor, multiplier: 1.0),
            loading.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0)
        ])
        
        loading.startAnimating()
    }
    
}

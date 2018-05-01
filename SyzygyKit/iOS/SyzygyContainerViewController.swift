//
//  SyzygyContainerViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class SyzygyContainerViewController: SyzygyViewController {
    private let contentProvider: Property<SyzygyViewController>
    private var content: SyzygyViewController?
    
    public init(content: Property<SyzygyViewController>) {
        contentProvider = content
        super.init(ui: .empty)
    }
    
    required public init?(coder: NSCoder) { Die.shutUpXcode() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        disposable += contentProvider.observe { [weak self] content in
            self?.transition(to: content)
            self?.content = content
        }
    }
    
}

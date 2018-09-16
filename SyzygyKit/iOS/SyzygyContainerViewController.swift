//
//  SyzygyContainerViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class SyzygyContainerViewController: SyzygyViewController {
    private let contentProvider: Property<PlatformViewController>
    private var content: PlatformViewController?
    
    public init(content: Property<PlatformViewController>) {
        contentProvider = content
        super.init(ui: .empty)
    }
    
    public convenience init(content: PlatformViewController) {
        self.init(content: Property(content))
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        disposable += contentProvider.observe { [weak self] content in
            let old = self?.content
            self?.content = content
            
            self?.replaceChild(old, with: content)
        }
    }
    
}

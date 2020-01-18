//
//  SyzygyContainerViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class SyzygyContainerViewController: SyzygyViewController {
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        disposable += contentProvider.observe { [weak self] content in
            self?.replaceChild(self?.content, with: content)
            self?.content = content
        }
    }
    
}

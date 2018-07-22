//
//  SyzygyWindowCoordinator.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/4/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import SyzygyCore

open class SyzygyWindowCoordinator: Coordinator {
    
    private lazy var window: UIWindow = {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = container
        return w
    }()
    
    private let container: SyzygyContainerViewController
    
    public init(content: Property<UIViewController>) {
        container = SyzygyContainerViewController(content: content)
        super.init()
    }
    
    public convenience init(content: UIViewController) {
        self.init(content: Property(content))
    }
    
    required public init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func start() {
        super.start()
        window.isHidden = false
        window.makeKeyAndVisible()
    }
    
    open override func stop() {
        window.resignKey()
        window.isHidden = true
    }
}

//
//  SyzygyWindowCoordinator.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/4/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import SyzygyCore

open class SyzygyWindowCoordinator: Coordinator {
    
    public private(set) lazy var window: UIWindow = {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = container
        return w
    }()
    
    private let container: SyzygyContainerViewController
    
    public var preferredStatusBarStyle: UIStatusBarStyle {
        get { return container.preferredStatusBarStyle }
        set { container.preferredStatusBarStyle = newValue }
    }
    
    public init(window: UIWindow? = nil, content: Property<UIViewController>) {
        container = SyzygyContainerViewController(content: content)
        super.init()
        
        if let w = window {
            self.window = w
            w.rootViewController = container
        }
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

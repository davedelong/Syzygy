//
//  SyzygySearchController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class SyzygySearchController: SyzygyViewController {
    
    private let content: PlatformViewController
    
    public let searchBar: UISearchBar
    
    public var searchDelegate: SyzygySearchDelegate? {
        didSet {
            if let d = searchDelegate {
                searchBar.delegate = d
                d.configureSearchBar(searchBar)
            }
        }
    }
    
    public convenience init(content: PlatformViewController) {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        self.init(content: content, searchBar: sb)
    }
    
    public init(content: PlatformViewController, searchBar: UISearchBar) {
        self.content = content
        self.searchBar = searchBar
        super.init(ui: .empty)
        navigationItem.titleView = searchBar
    }
    
    public required init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        embedChild(content)
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
}

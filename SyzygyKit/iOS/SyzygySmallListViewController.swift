//
//  SyzygySmallListViewController.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 2/3/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

open class SyzygySmallListViewController<T>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var table: UITableViewController = {
        let tvc = UITableViewController(style: .plain)
        tvc.tableView.dataSource = self
        tvc.tableView.delegate = self
        tvc.tableView.rowHeight = UITableView.automaticDimension
        tvc.tableView.estimatedRowHeight = 64
        tvc.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Empty")
        return tvc
    }()
    
    private let contents: Property<Array<T>>
    private let disposable = CompositeDisposable()
    private let _extractor: (T) -> UIViewController
    private var _contents = Array<T>()
    
    public var selectionHandler: ((T) -> Void)?
    public var showSeparators: Bool = true {
        didSet {
            table.tableView.separatorStyle = showSeparators ? .singleLine : .none
        }
    }
    
    public init(contents: Property<Array<T>>, viewControllerExtractor: @escaping (T) -> UIViewController) {
        self.contents = contents
        self._extractor = viewControllerExtractor
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) { Abort.because(.notYetImplemented) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        embedChild(table)
        disposable += contents.observe { [weak self] vcs in
            self?.transitionToTableContent(vcs)
        }
    }
    
    private func transitionToTableContent(_ newContent: Array<T>) {
        _contents = newContent
        newContent.forEach {
            let vc = _extractor($0)
            if vc.parent != nil && vc.parent != table {
                vc.viewIfLoaded?.removeFromSuperview()
                vc.willMove(toParent: nil)
                vc.removeFromParent()
            }
            
            if vc.parent != table {
                table.addChild(vc)
                vc.didMove(toParent: table)
            }
        }
        table.tableView.reloadData()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _contents.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = _extractor(_contents[indexPath.row])
        guard let rowView = row.view else { Abort.because("Row VCs must have a view") }
        
        if let cellView = rowView as? UITableViewCell { return cellView }
        
        let empty = tableView.dequeueReusableCell(withIdentifier: "Empty", for: indexPath)
        empty.contentView.embedSubview(rowView)
        return empty
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = _contents[indexPath.row]
        selectionHandler?(row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SyzygySmallListViewController where T == UIViewController {
    
    public convenience init(contents: Property<Array<UIViewController>>) {
        self.init(contents: contents, viewControllerExtractor: { $0 })
    }
}

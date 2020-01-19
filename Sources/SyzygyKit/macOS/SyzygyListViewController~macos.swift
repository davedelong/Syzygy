//
//  SyzygyListViewController~macos.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

import Foundation

open class SyzygyListViewController<T: SyzygyViewController>: SyzygyViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    private let contents: Property<Array<T>>
    private var _rows = Array<T>()
    
    @IBOutlet private var table: NSTableView?
    
    private var _selection = MutableProperty<T?>(nil)
    public var selectedItem: Property<T?> { return _selection }
    
    public init(contents: Property<Array<T>>) {
        self.contents = contents
        super.init(ui: .explicit("SyzygyListViewController", Bundle(for: SyzygyListViewController<T>.self)))
    }
    
    required public init?(coder aDecoder: NSCoder) { Abort.because(.notYetImplemented) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        disposable += contents.observe { [weak self] vcs in
            self?.transitionToTableContent(vcs)
        }
    }
    
    private func transitionToTableContent(_ newContent: Array<T>) {
        _rows = newContent
        
        let selected = _selection.value
        newContent.forEach { vc in
            if vc.parent != nil && vc.parent != self {
                vc.viewIfLoaded?.removeFromSuperview()
                vc.removeFromParent()
            }
            
            if vc.parent != self {
                addChild(vc)
            }
        }
        
        if let s = selected, let index = newContent.firstIndex(of: s) {
            table?.selectRowIndexes([index], byExtendingSelection: false)
        } else {
            table?.deselectAll(self)
        }
        updateSelection()
        
        table?.reloadData()
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return _rows.count
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let vc = _rows[row]
        let colors = NSColor.controlAlternatingRowBackgroundColors
        let colorIndex = row % colors.count
        vc.defaultBackgroundColor.value = colors[colorIndex]
        return vc.view
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let row = _rows[row]
        return row.selectable.value
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        let row = table?.selectedRow ?? -1
        if _rows.indices.contains(row) {
            _selection.value = _rows[row]
        } else {
            _selection.value = nil
        }
        updateSelection()
    }
    
    private func updateSelection() {
        let row = table?.selectedRow ?? -1
        for (index, vc) in _rows.enumerated() {
            let selected = index == row
            vc.wantsSelection.value = selected
        }
    }
    
}

#endif

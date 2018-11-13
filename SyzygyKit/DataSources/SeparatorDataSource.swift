//
//  SeparatorDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation


extension Set where Element == SeparatorDataSource.Placement {
    public static var surround: Set<Element> = [.before, .inBetween, .after]
    public static var `default`: Set<Element> = [.inBetween, .after]
}

open class SeparatorDataSource: AnyDataSource {
    
    public enum Placement: Option, CaseIterable {        
        case before
        case inBetween
        case after
    }
    
    private let child: AnyDataSource
    private let separators: Set<Placement>
    
    public init(child: AnyDataSource, separatorPlacement: Set<Placement> = .default) {
        self.child = child
        self.separators = separatorPlacement
        super.init(name: child.name)
        child.move(to: self)
    }
    
    private func childIndex(for index: Int) -> Int? {
        var newIndex = index
        
        if separators.contains(.before) && index == 0 {
            return nil
        }
        if separators.contains(.after) && index == numberOfItems() - 1 {
            return nil
        }
        
        if separators.contains(.before) {
            newIndex -= 1
        }
        if separators.contains(.inBetween) {
            guard newIndex % 2 == 0 else { return nil }
            newIndex /= 2
        }
        return newIndex
    }
    
    private func index(for childIndex: Int) -> Int {
        var newIndex = childIndex
        
        if separators.contains(.inBetween) {
            newIndex = childIndex * 2
        }
        
        if separators.contains(.before) {
            newIndex += 1
        }
        
        return newIndex
    }
    
    // Abstract overrides
    
    override func numberOfItems() -> Int {
        var n = child.numberOfItems()
        if n == 0 { return 0 }
        
        if separators.contains(.inBetween) {
            n += (n - 1)
        }
        if separators.contains(.before) { n += 1 }
        if separators.contains(.after) { n += 1 }
        
        return n
    }
    
    override func registerWithParent() {
        parent?.register(class: SeparatorView.self, for: "Separator")
        child.registerWithParent()
    }
    
    override func cellForItem(at index: Int) -> DataSourceRowView? {
        if let childIndex = self.childIndex(for: index) {
            return child.cellForItem(at: childIndex)
        } else {
            // it's a separator cell
            return parent?.child(self, dequeueCellFor: "Separator")
        }
    }
    
    override func didSelectItem(at index: Int) {
        let childIndex = self.childIndex(for: index) !! "Separator lines are not selectable"
        child.didSelectItem(at: childIndex)
    }
    
    override func contextualActions(at index: Int) -> Array<Action> {
        if let childIndex = self.childIndex(for: index) {
            return child.contextualActions(at: childIndex)
        } else {
            return []
        }
    }
    
}

extension SeparatorDataSource: DataSourceParent {
    
    public func register(nib: PlatformNib, for cellReuseIdentifier: String) {
        parent?.register(nib: nib, for: cellReuseIdentifier)
    }
    
    public func register(class aClass: AnyClass, for cellReuseIdentifier: String) {
        parent?.register(class: aClass, for: cellReuseIdentifier)
    }
    
    public func child(_ child: AnyDataSource, dequeueCellFor reuseIdentifier: String) -> DataSourceRowView? {
        return parent?.child(self, dequeueCellFor: reuseIdentifier)
    }
    
    public func childWillBeginBatchedChanges(_ child: AnyDataSource) {
        parent?.childWillBeginBatchedChanges(self)
    }
    
    public func child(_ child: AnyDataSource, didInsertItemAt index: Int, semantic: DataSourceChangeSemantic) {
        let numberOfChildItems = child.numberOfItems()
        
        if numberOfChildItems == 1 && separators.contains(.before) {
            parent?.child(self, didInsertItemAt: 0, semantic: semantic)
        }
        
        let translatedIndex = self.index(for: index)
        parent?.child(self, didInsertItemAt: translatedIndex, semantic: semantic)
        
        if numberOfChildItems == 1 && separators.contains(.after) {
            parent?.child(self, didInsertItemAt: translatedIndex + 1, semantic: semantic)
        }
        
        if numberOfChildItems > 1 && separators.contains(.inBetween) {
            parent?.child(self, didInsertItemAt: translatedIndex + 1, semantic: semantic)
        }
    }
    
    public func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic) {
        let numberOfChildItems = child.numberOfItems()
        
        if numberOfChildItems == 0 && separators.contains(.before) {
            parent?.child(self, didRemoveItemAt: 0, semantic: semantic)
        }
        
        let translatedIndex = self.index(for: index)
        parent?.child(self, didRemoveItemAt: translatedIndex, semantic: semantic)
        
        if numberOfChildItems == 0 && separators.contains(.after) {
            parent?.child(self, didRemoveItemAt: translatedIndex + 1, semantic: semantic)
        }
        
        if numberOfChildItems > 0 && separators.contains(.inBetween) {
            parent?.child(self, didRemoveItemAt: translatedIndex + 1, semantic: semantic)
        }
    }
    
    public func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int) {
        let translatedOld = self.index(for: oldIndex)
        let translatedNew = self.index(for: newIndex)
        
        parent?.child(self, didMoveItemAt: translatedOld, to: translatedNew)
    }
    
    public func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic) {
        let translatedIndex = self.index(for: index)
        parent?.child(self, wantsReloadOfItemAt: translatedIndex, semantic: semantic)
    }
    
    public func childDidEndBatchedChanges(_ child: AnyDataSource) {
        parent?.childDidEndBatchedChanges(self)
    }
}

internal class SeparatorView: DataSourceRowView {
    
    private var line: PlatformView?
    private var height: NSLayoutConstraint?
    
    #if BUILDING_FOR_DESKTOP
    override func awakeFromNib() {
        super.awakeFromNib()
        guard line == nil else { return }
        
        let l = NSBox(orientation: .horizontal)
        setup(line: l, in: self)
    }
    
    override func viewDidMoveToWindow() {
        let scale = max(window?.backingScaleFactor ?? 1.0, 1.0)
        let onePixel = 1 / scale
        height?.constant = onePixel
    }
    #endif
    
    #if BUILDING_FOR_MOBILE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let l = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 1))
        l.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        setup(line: l, in: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let l = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 1))
        l.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        setup(line: l, in: contentView)
    }
    
    override func didMoveToWindow() {
        let scale = max(window?.screen.scale ?? 1.0, 1.0)
        let onePixel = 1 / scale
        height?.constant = onePixel
    }
    #endif
    
    private func setup(line: PlatformView, in parent: PlatformView) {
        line.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(line)
        
        let h = line.heightAnchor.constraint(equalToConstant: 1.0)
        
        #if BUILDING_FOR_MOBILE
        let leading = line.leadingAnchor.constraint(equalToSystemSpacingAfter: parent.leadingAnchor, multiplier: 1.0)
        #else
        let leading = line.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 20)
        #endif
        
        NSLayoutConstraint.activate([
            leading,
            parent.trailingAnchor.constraint(equalTo: line.trailingAnchor),
            
            line.topAnchor.constraint(equalTo: parent.topAnchor),
            parent.bottomAnchor.constraint(equalTo: line.bottomAnchor),
            
            h
        ])
        
        self.height = h
        self.line = line
        selectable = false
    }
    
}

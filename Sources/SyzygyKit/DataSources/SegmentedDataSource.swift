//
//  SegmentedDataSource.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 8/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Abort.Reason {
    static func child(_ child: AnyDataSource, mustBe current: AnyDataSource) -> Abort.Reason {
        return Abort.Reason("Child \(child) is not the expected \(current)")
    }
}

open class SegmentedDataSource: AnyDataSource {
    
    public enum ChangeSemantic {
        case horizontal
        case vertical
    }
    
    private var children = Array<AnyDataSource>()
    private var currentIndex = 0
    private var current: AnyDataSource { return children[currentIndex] }
    private var switchingChildren = false
    private let changeSemantic: ChangeSemantic
    
    private let selectionCell: SegmentedCell
    
    public init(name: String, children: Array<AnyDataSource>, changeSemantic: ChangeSemantic = .vertical) {
        Assert.that(children.isNotEmpty, because: "Cannot create a SegmentedDataSource with no segments")
        self.children = children
        self.changeSemantic = changeSemantic
        
        let titles = children.map { $0.name }
        self.selectionCell = SegmentedCell(titles: titles)
        
        super.init(name: name)
        
        self.selectionCell.selectionChanged = { [weak self] index in
            self?.switchToSegment(at: index)
        }
    }
    
    public func switchToSegment(at index: Int, animated: Bool = true) {
        guard index != currentIndex else { return }
        Assert.that(index >= 0, because: "Segment indexes cannot be negative (\(index))")
        Assert.that(index < children.count, because: "Cannot switch to nonexistent segment \(index)")
        
        let old = current
        let oldIndex = currentIndex
        
        let new = children[index]
        let newIndex = index
        
        switchingChildren = true
        old.move(to: nil)
        new.move(to: self)
        currentIndex = index
        switchingChildren = false
        
        parent?.childWillBeginBatchedChanges(self)
        
        if changeSemantic == .vertical {
        
            let rowsToReload = min(old.numberOfItems(), new.numberOfItems())
            let rowsToInsert = new.numberOfItems() - old.numberOfItems()
            
            for i in 0 ..< rowsToReload {
                parent?.child(self,
                              wantsReloadOfItemAt: i + 1,
                              semantic: animated ? .inPlace : .instantaneous)
            }
            
            if rowsToInsert < 0 {
                // delete some rows
                for i in 0 ..< abs(rowsToInsert) {
                    parent?.child(self,
                                  didRemoveItemAt: 1 + rowsToReload + i,
                                  semantic: animated ? .exitBottomToTop : .instantaneous)
                }
            } else {
                // insert some rows
                for i in 0 ..< rowsToInsert {
                    parent?.child(self,
                                  didInsertItemAt: 1 + rowsToReload + i,
                                  semantic: animated ? .enterTopToBottom : .instantaneous)
                }
            }
            
        } else {
            let removeDirection: DataSourceChangeSemantic
            let insertDirection: DataSourceChangeSemantic
            
            if animated {
                if oldIndex < newIndex {
                    // moving left-to-right
                    removeDirection = .exitLeftToRight
                    insertDirection = .enterLeftToRight
                } else {
                    // moving right-to-left
                    removeDirection = .exitRightToLeft
                    insertDirection = .enterRightToLeft
                }
            } else {
                removeDirection = .instantaneous
                insertDirection = .instantaneous
            }
            
            for i in 0 ..< old.numberOfItems() {
                parent?.child(self, didRemoveItemAt: i + 1, semantic: removeDirection)
            }
            for i in 0 ..< new.numberOfItems() {
                parent?.child(self, didInsertItemAt: i + 1, semantic: insertDirection)
            }
        }
        parent?.childDidEndBatchedChanges(self)
    }
    
    override func numberOfItems() -> Int {
        return 1 + current.numberOfItems()
    }
    
    override func didSelectItem(at index: Int) {
        current.didSelectItem(at: index - 1)
    }
    
    override func registerWithParent() {
        current.registerWithParent()
    }
    
    override func cellForItem(at index: Int) -> DataSourceRowView? {
        if index == 0 {
            return selectionCell
        } else {
            return current.cellForItem(at: index - 1)
        }
    }
    
    override func contextualActions(at index: Int) -> Array<Action> {
        if index == 0 {
            return []
        } else {
            return current.contextualActions(at: index - 1)
        }
    }
    
}

extension SegmentedDataSource: DataSourceParent {
    
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
        guard switchingChildren == false else { return }
        parent?.childWillBeginBatchedChanges(self)
    }
    
    public func child(_ child: AnyDataSource, didInsertItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, mustBe: current))
        parent?.child(self, didInsertItemAt: index + 1, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didRemoveItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, mustBe: current))
        parent?.child(self, didRemoveItemAt: index + 1, semantic: semantic)
    }
    
    public func child(_ child: AnyDataSource, didMoveItemAt oldIndex: Int, to newIndex: Int) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, mustBe: current))
        parent?.child(self, didMoveItemAt: oldIndex + 1, to: newIndex + 1)
    }
    
    public func child(_ child: AnyDataSource, wantsReloadOfItemAt index: Int, semantic: DataSourceChangeSemantic) {
        guard switchingChildren == false else { return }
        Assert.that(child == current, because: .child(child, mustBe: current))
        parent?.child(self, wantsReloadOfItemAt: index + 1, semantic: semantic)
    }
    
    public func childDidEndBatchedChanges(_ child: AnyDataSource) {
        guard switchingChildren == false else { return }
        parent?.childDidEndBatchedChanges(self)
    }
    
    
}

internal class SegmentedCell: DataSourceRowView {
    
    var selectionChanged: ((Int) -> Void)?
    
    #if BUILDING_FOR_DESKTOP
    
    private let control: NSSegmentedControl
    
    init(titles: Array<String>) {
        control = NSSegmentedControl()
        super.init(frame: .zero)
        control.segmentStyle = .capsule
        control.trackingMode = .selectOne
        control.segmentDistribution = .fit
        addSubview(control)
        control.segmentCount = titles.count
        for (index, title) in titles.enumerated() {
            control.setLabel(title, forSegment: index)
        }
        control.selectedSegment = 0
        control.target = self
        control.action = #selector(segmentAction(_:))
        
        NSLayoutConstraint.activate([
            control.centerXAnchor.constraint(equalTo: centerXAnchor),
            control.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(greaterThanOrEqualTo: control.trailingAnchor, constant: 20),
            control.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
    
    @IBAction private func segmentAction(_ segment: NSSegmentedControl) {
        selectionChanged?(segment.selectedSegment)
    }
    
    #elseif BUILDING_FOR_UIKIT
    
    private let control: UISegmentedControl
    
    init(titles: Array<String>) {
        self.control = UISegmentedControl()
        super.init(style: .default, reuseIdentifier: nil)
        addSubview(control)
        control.removeAllSegments()
        for (index, title) in titles.enumerated() {
            control.insertSegment(withTitle: title, at: index, animated: false)
        }
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
    }
    
    @IBAction private func segmentAction(_ segment: UISegmentedControl) {
        selectionChanged?(segment.selectedSegmentIndex)
    }
    
    #endif
    
    required init?(coder: NSCoder) { Abort.because(.shutUpXcode) }
}

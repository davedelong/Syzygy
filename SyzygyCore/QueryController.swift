//
//  QueryController.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

open class QueryController<T: Equatable> {
    
    public struct Section: Hashable {
        public static func ==(lhs: Section, rhs: Section) -> Bool { return lhs.name == rhs.name }
        
        public var hashValue: Int { return name.hashValue }
        
        public let name: String
        public let indexTitle: String?
        public let representedObject: Any?
        public let numberOfObjects: Int
        public let objects: Array<T>
        
        public init(name: String, indexTitle: String? = nil, representedObject: Any? = nil, objects: Array<T>) {
            self.name = name
            self.indexTitle = indexTitle
            self.representedObject = representedObject
            self.objects = objects
            self.numberOfObjects = objects.count
        }
    }
    
    public var numberOfSections: Int {
        performQueryImmediatelyIfNecessary()
        return _sectionCount
    }
    public private(set) var totalNumberOfObjects: Int = 0
    public private(set) var isPerformingBatchConfiguration: Bool = false
    public let disposable = CompositeDisposable()
    
    private var _sectionCount = 0
    private var _needsQuery = true
    
    private let _queryTickle = MutableProperty(())
    private let _coalescedTickle: Property<Void>
    private let _contents = MutableProperty<Array<Section>>([])
    public var contents: Property<Array<Section>> {
        performQueryImmediatelyIfNecessary()
        return _contents
    }
    
    public init() {
        _coalescedTickle = _queryTickle.coalesce(after: 0.3)
        disposable += _coalescedTickle.observeNext { [weak self] in
            self?.performQueryImmediatelyIfNecessary()
        }
    }
    
    open func setNeedsPerformQuery() {
        _needsQuery = true
        _queryTickle.tickle()
    }
    
    public func performBatchConfiguration(_ configure: () -> Void) {
        isPerformingBatchConfiguration = true
        configure()
        setNeedsPerformQuery()
        isPerformingBatchConfiguration = false
    }
    
    open func performQuery() -> Array<Section>? { return nil }
    
    private func performQueryImmediatelyIfNecessary() {
        guard _needsQuery == true else { return }
        guard isPerformingBatchConfiguration == false else { return }
        let queryResults = performQuery()
        _needsQuery = false
        guard let sections = queryResults else { return }
        
        totalNumberOfObjects = sections.sum { $0.numberOfObjects }
        _sectionCount = sections.count
        _contents.value = sections
    }
    
    public func numberOfObjects(in section: Int) -> Int {
        guard section >= 0 else { return 0 }
        let contents = _contents.value
        guard section < contents.count else { return 0 }
        let s = contents[section]
        return s.numberOfObjects
    }
    
    public func object(at indexPath: IndexPath) -> T? {
        performQueryImmediatelyIfNecessary()
        guard indexPath.section >= 0 else { return nil }
        let contents = _contents.value
        guard indexPath.section < contents.count else { return nil }
        let section = contents[indexPath.section]
        
        guard indexPath.row < section.numberOfObjects else { return nil }
        guard indexPath.row >= 0 else { return nil }
        return section.objects[indexPath.row]
    }
    
    public func indexPath(of object: T) -> IndexPath? {
        performQueryImmediatelyIfNecessary()
        let contents = _contents.value
        for (sectionIndex, section) in contents.enumerated() {
            if let rowIndex = section.objects.index(of: object) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
    public func contains(_ object: T) -> Bool { return indexPath(of: object) != nil }
    
}

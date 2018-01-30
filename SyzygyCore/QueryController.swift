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
        performQueryIfNecessary()
        return _sectionCount
    }
    public private(set) var totalNumberOfObjects: Int = 0
    public private(set) var isPerformingBatchConfiguration: Bool = false
    
    private var _sectionCount = 0
    private var _hasQueried = false
    private let _contents = MutableProperty<Array<Section>>([])
    public var contents: Property<Array<Section>> { return _contents }
    
    public init() { }
    
    public func performBatchConfiguration(_ configure: () -> Void) {
        isPerformingBatchConfiguration = true
        configure()
        isPerformingBatchConfiguration = false
        performQuery()
    }
    
    open func performQuery() { return }
    
    private func performQueryIfNecessary() {
        guard _hasQueried == false else { return }
        guard isPerformingBatchConfiguration == false else { return }
        performQuery()
    }
    
    public func transition(to newContent: Array<Section>) {
        
        guard isPerformingBatchConfiguration == false else {
            fatalError("Attempt to transition to content before finishing a batch configuration")
        }
        totalNumberOfObjects = newContent.sum { $0.numberOfObjects }
        _sectionCount = newContent.count
        _contents.value = newContent
        _hasQueried = true
    }
    
    public func numberOfObjects(in section: Int) -> Int {
        guard section >= 0 else { return 0 }
        let contents = _contents.value
        guard section < contents.count else { return 0 }
        let s = contents[section]
        return s.numberOfObjects
    }
    
    public func object(at indexPath: IndexPath) -> T? {
        performQueryIfNecessary()
        guard indexPath.section >= 0 else { return nil }
        let contents = _contents.value
        guard indexPath.section < contents.count else { return nil }
        let section = contents[indexPath.section]
        
        guard indexPath.row < section.numberOfObjects else { return nil }
        guard indexPath.row >= 0 else { return nil }
        return section.objects[indexPath.row]
    }
    
    public func indexPath(of object: T) -> IndexPath? {
        performQueryIfNecessary()
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

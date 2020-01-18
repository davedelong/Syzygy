//
//  SharedFileList.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 9/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class SharedFileList {
    
    public static let sessionLoginItems = SharedFileList(_LSSharedFileList.sessionLoginItems())
    
    private let list: _LSSharedFileList
    public let items: Property<Set<URL>>
    
    private init(_ list: _LSSharedFileList) {
        self.list = list;
        let mItems = MutableProperty(list.items)
        self.items = mItems.skipRepeats()
        self.list.changeHandler = { aList in
            mItems.value = aList.items
        }
    }
    
    deinit {
        list.changeHandler = nil
    }
    
    public func contains(_ item: URL) -> Bool {
        return list.containsItem(item)
    }
    
    public func add(_ item: URL) {
        list.addItem(item)
    }
    
    public func remove(_ item: URL) {
        list.removeItem(item)
    }
    
}

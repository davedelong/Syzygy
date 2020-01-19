//
//  Property+BookmarkMetadata.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core
import Structures
import Properties

public extension MutableProperty where T: PlistConvertible {
    
    convenience init(bookmark: Bookmark, key: String, defaultValue: T) {
        let persisted: T? = bookmark[key]
        let initial = persisted ?? defaultValue
        self.init(initial)
        
        observeNext { [weak bookmark] in
            bookmark?[key] = $0
        }
    }
    
}

public extension MutableProperty where T: OptionalType, T.ValueType: PlistConvertible {
    
    convenience init(bookmark: Bookmark, key: String, defaultValue: T) {
        let persisted: T.ValueType? = bookmark[key] ?? defaultValue.optionalValue
        let initial: T = T.init(persisted)
        self.init(initial)
        
        observeNext { [weak bookmark] in
            bookmark?[key] = $0.optionalValue
        }
    }
    
}

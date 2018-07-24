//
//  String+Sorting.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension String {
    
    public struct Sorter<B>: Sorting {
        private let ordersBefore: (B, B) -> Bool
        
        public init<S: ValueSorting>(_ s: S, options: String.CompareOptions = [], locale: Locale? = nil)
            where S.Base == B, S.Value: StringProtocol, S.Value.Index == String.Index {
            
            ordersBefore = { l, r -> Bool in
                let v1 = s.value(from: l)
                let v2 = s.value(from: r)
                return v1.compare(v2, options: options, locale: locale) == .orderedAscending
            }
            
        }
        
        public func orders(_ a: B, before: B) -> Bool {
            return ordersBefore(a, before)
        }
    }
    
}

extension ValueSorting where Value: StringProtocol, Value.Index == String.Index {
    
    public func using(options: String.CompareOptions = [], locale: Locale?) -> String.Sorter<Base> {
        return String.Sorter(self, options: options, locale: locale)
    }
    
}

//
//  String+Sorting.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension String {
    
    struct Sorter<B>: Sorting {
        fileprivate let ordersBefore: (B, B) -> Bool
        
        public init<S: ValueSorting>(_ s: S, options: String.CompareOptions = [], locale: Locale? = nil)
            where S.Base == B, S.Value: StringProtocol {
            
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
    
    static func localizedCaseInsensitiveCompare() -> Sorter<String> {
        return Sorter(options: [.caseInsensitive], locale: .current)
    }
    
}

public extension String.Sorter where B == String {
    
    init(options: String.CompareOptions = [], locale: Locale? = nil, order: ComparisonResult = .orderedAscending) {
        ordersBefore = {
            return $0.compare($1, options: options, locale: locale) == order
        }
    }
    
}

extension ValueSorting where Value: StringProtocol {
    
    public func using(options: String.CompareOptions = [], locale: Locale?) -> String.Sorter<Base> {
        return String.Sorter(self, options: options, locale: locale)
    }
    
}

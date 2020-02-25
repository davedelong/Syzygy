//
//  File.swift
//  
//
//  Created by Dave DeLong on 2/25/20.
//

import Foundation

public extension Sorter where Element == String {
    
    static func comparing(with options: String.CompareOptions, locale: Locale? = nil, direction: SortDirection) -> Sorter<Element> { 
        return Sorter { (lhs, rhs) -> SortOrdering in
            let comparison = lhs.compare(rhs, options: options, locale: locale)
            if comparison == .orderedAscending { return direction == .ascending ? .ascending : .descending }
            if comparison == .orderedDescending { return direction == .descending ? .descending : .ascending }
            return .equal
        }
    }
    
    static var localized: Sorter<String> {
        comparing(with: [], locale: .current, direction: .ascending)
    }
    
    static var localizedCaseInsensitive: Sorter<String> {
        comparing(with: [.caseInsensitive], locale: .current, direction: .ascending)
    }
}

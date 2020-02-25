//
//  File.swift
//  
//
//  Created by Dave DeLong on 2/25/20.
//

import Foundation

extension Sorter {
    
    public init(sortDescriptor: NSSortDescriptor) {
        self.compare = { lhs, rhs in
            let comparison = sortDescriptor.compare(lhs, to: rhs)
            switch comparison {
                case .orderedSame: return .equal
                case .orderedAscending: return .ascending
                case .orderedDescending: return .descending
            }
        }
    }
    
}

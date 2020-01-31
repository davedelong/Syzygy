//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import Foundation

internal enum Retrieved<T> {
    case unretrieved
    case inProgress(DispatchWorkItem)
    case retrieved(T)
    
    var isUnretrieved: Bool {
        guard case .unretrieved = self else { return false }
        return true
    }
    
    var isInProgress: Bool {
        guard case .inProgress(_) = self else { return false }
        return true
    }
    
    var isRetrieved: Bool {
        guard case .retrieved(_) = self else { return false }
        return true
    }
    
    var inProgressWork: DispatchWorkItem? {
        guard case .inProgress(let work) = self else { return nil }
        return work
    }
}

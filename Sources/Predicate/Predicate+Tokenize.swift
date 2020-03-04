//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

extension String {
    
    public func tokenize() -> Predicate<String> {
        let terms = self.extractTerms()
        guard terms.isEmpty == false else { return .true }
        
        let predicates = terms.map { t -> Predicate<String> in
            
            let p: Predicate<String>
            if t.hasPrefix("-") == false {
                p = Predicate { s in
                    return s.localizedCaseInsensitiveContains(t) == true
                }
            } else {
                let remainder = t.dropFirst()
                p = Predicate { s -> Bool in
                    return s.localizedCaseInsensitiveContains(remainder) == false
                }
            }
            return p
        }
        
        return Predicate.and(predicates)
    }
    
}

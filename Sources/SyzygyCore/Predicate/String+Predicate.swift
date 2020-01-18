//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

extension String {
    
    public func tokenize() -> AnyPredicate<String> {
        let terms = self.extractTerms()
        guard terms.isEmpty == false else { return .true }
        
        let predicates = terms.map { t -> AnyPredicate<String> in
            
            let p: AnyPredicate<String>
            if t.hasPrefix("-") == false {
                p = AnyPredicate<String> { s in
                    return s.localizedCaseInsensitiveContains(t) == true
                }
            } else {
                let remainder = t.dropFirst()
                p = AnyPredicate<String> { s -> Bool in
                    return s.localizedCaseInsensitiveContains(remainder) == false
                }
            }
            return p
        }
        
        let anded = AndPredicate(predicates)
        return AnyPredicate(anded)
    }
    
}

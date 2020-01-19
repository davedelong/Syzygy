//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation
import HTTP

extension HTTPLoader {
    
    func reset(completion: @escaping () -> Void) {
        let g = DispatchGroup()
        reset(with: g)
        g.notify(queue: .main, execute: completion)
    }
    
}

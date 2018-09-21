//
//  Property+Debug.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 9/13/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Property {
    
    public func log(from file: StaticString = #file, line: UInt = #line, function: StaticString = #function) -> Property {
        
        observeNext { value in
            print("Property<\(T.self)> (Created at \(function):\(line)) received \(value)")
        }
        
        return self
    }
    
    
}

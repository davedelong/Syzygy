//
//  URLRouting.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public protocol URLRouting: class {
    
    func performRouting(for urlComponents: URLComponents) -> Bool
    
}

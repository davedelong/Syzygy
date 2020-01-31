//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import Foundation

func async(after: TimeInterval = 0, execute: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + after, execute: execute)
}

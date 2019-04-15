//
//  RandomAccessCollection.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 5/24/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension RandomAccessCollection {
    
    func randomElement() -> Element {
        guard count > 0 else { fatalError() }
        let randomOffset = Int(arc4random()) % indices.count
        let randomIndex = indices.index(indices.startIndex, offsetBy: randomOffset)
        return self[randomIndex]
    }
    
}

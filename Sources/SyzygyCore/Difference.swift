//
//  Difference.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 9/21/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import DifferenceKit

public extension RangeReplaceableCollection where Element: Differentiable {
    
    func difference(to new: Self) -> StagedChangeset<Self> {
        return StagedChangeset(source: self, target: new)
    }
    
}

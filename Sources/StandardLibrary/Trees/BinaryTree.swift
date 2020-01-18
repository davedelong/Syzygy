//
//  BinaryTree.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol BinaryTreeNode: TreeNode {
    
    var left: Self? { get }
    var right: Self? { get }
    
}

public extension BinaryTreeNode {
    
    var isLeaf: Bool { return left == nil && right == nil }
    
    var children: Array<Self> {
        if let l = left, let r = right { return [l, r] }
        if let l = left { return [l] }
        if let r = right { return [r] }
        return []
    }
    
}

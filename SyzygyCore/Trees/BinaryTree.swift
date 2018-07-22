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
    
    public var children: Array<Self> {
        if let l = left, let r = right { return [l, r] }
        if let l = left { return [l] }
        if let r = right { return [r] }
        return []
    }
    
}

public struct InOrderTraversal<N: BinaryTreeNode>: TreeTraversing {
    public typealias Node = N
    
    public enum Disposition: TreeTraversingDisposition {
        case `continue`
        case abort
        case skipChildren
        public var aborts: Bool { return self == .abort }
    }
    
    public func traverse(node: N, visitor: (N) throws -> InOrderTraversal<N>.Disposition) rethrows -> InOrderTraversal<N>.Disposition {
        if let l = node.left {
            let d = try traverse(node: l, visitor: visitor)
            if d.aborts { return d }
        }
        
        let d = try visitor(node)
        if d.aborts { return d }
        
        if let r = node.right, d != .skipChildren {
            let d = try traverse(node: r, visitor: visitor)
            if d.aborts { return d }
        }
        
        return .continue
    }
}

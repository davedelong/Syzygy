//
//  TraversalAlgorithms.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct PreOrderTraversal<N: TreeNode>: TreeTraversing {
    public typealias Node = N
    
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
        case skipChildren
        public var aborts: Bool { return self == .abort }
    }
    
    public init() { }
    
    public func traverse(node: N, visitor: (N) throws -> PreOrderTraversal.Disposition) rethrows -> PreOrderTraversal.Disposition {
        let d = try visitor(node)
        if d.aborts { return d }
        
        if d != .skipChildren {
            for child in node.children {
                let nodeD = try traverse(node: child, visitor: visitor)
                if nodeD.aborts { return nodeD }
            }
        }
        return .continue
    }
    
}

public struct PostOrderTraversal<N: TreeNode>: TreeTraversing {
    public typealias Node = N
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
        public var aborts: Bool { return self == .abort }
    }
    
    public init() { }
    
    public func traverse(node: N, visitor: (N) throws -> PostOrderTraversal<N>.Disposition) rethrows -> PostOrderTraversal<N>.Disposition {
        for child in node.children {
            let nodeD = try traverse(node: child, visitor: visitor)
            if nodeD.aborts { return nodeD }
        }
        
        return try visitor(node)
    }
}

public struct BreadthFirstTreeTraversal<N: TreeNode>: TreeTraversing {
    public typealias Node = N
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
        case skipChildren
        public var aborts: Bool { return self == .abort }
    }
    
    public func traverse(node: N, visitor: (N) throws -> BreadthFirstTreeTraversal<N>.Disposition) rethrows -> BreadthFirstTreeTraversal<N>.Disposition {
        var nodesToVisit = ArraySlice([node])
        
        while let next = nodesToVisit.popFirst() {
            let nodeDisposition = try visitor(next)
            switch nodeDisposition {
                case .abort: return .abort
                case .continue: nodesToVisit.append(contentsOf: next.children)
                case .skipChildren: continue
            }
        }
        
        return .continue
        
    }
    
}

// In-order traversal only works on binary tree nodes, because general tree nodes don't have a notion of "left" or "right" children
public struct InOrderTraversal<N: BinaryTreeNode>: TreeTraversing {
    public typealias Node = N
    
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
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

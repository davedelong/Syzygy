//
//  Tree.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/21/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol TreeNode {
    
    var isLeaf: Bool { get }
    var children: Array<Self> { get }
    
}

public enum TreeTraversalDisposition {
    case abort
    case `continue`
    case skipChildren
}

public protocol TreeTraversing {
    func traverse<T: TreeNode>(node: T, visitor: (T) throws -> TreeTraversalDisposition) rethrows -> TreeTraversalDisposition
}

public extension TreeNode {
    
    var isLeaf: Bool { return children.isEmpty }
    
    @discardableResult
    public func traverse(in order: TreeTraversing = DepthFirstTreeTraversal(order: .preOrder), visitor: (Self) throws -> TreeTraversalDisposition) rethrows -> TreeTraversalDisposition {
        return try order.traverse(node: self, visitor: visitor)
    }
    
}

public extension Collection where Element: TreeNode {
    
    public func traverseElements(in order: TreeTraversing = DepthFirstTreeTraversal(order: .preOrder), visitor: (Element) throws -> TreeTraversalDisposition) rethrows {
        for item in self {
            let d = try item.traverse(in: order, visitor: visitor)
            if d == .abort { return }
        }
    }
    
}

public struct DepthFirstTreeTraversal: TreeTraversing {
    public enum Order {
        case preOrder
        case postOrder
    }
    
    public let order: Order
    
    public init(order: Order = .preOrder) {
        self.order = order
    }
    
    public func traverse<T>(node: T, visitor: (T) throws -> TreeTraversalDisposition) rethrows -> TreeTraversalDisposition where T : TreeNode {
        let children = node.children
        
        var childrenToTraverse = Array<T>()
        
        if order == .preOrder {
            let nodeDisposition = try visitor(node)
            if nodeDisposition == .abort { return .abort }
            if nodeDisposition != .skipChildren {
                childrenToTraverse.append(contentsOf: children)
            }
        }
        
        for child in childrenToTraverse {
            let d = try traverse(node: child, visitor: visitor)
            if d == .abort { return .abort }
        }
        
        if order == .postOrder {
            let nodeDisposition = try visitor(node)
            if nodeDisposition == .abort { return .abort }
        }
        
        return .continue
    }
    
}

public struct BreadthFirstTreeTraversal: TreeTraversing {
    
    public func traverse<T>(node: T, visitor: (T) throws -> TreeTraversalDisposition) rethrows -> TreeTraversalDisposition where T : TreeNode {
        var nodesToVisit = [node]
        
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

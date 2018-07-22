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

public protocol TreeTraversingDisposition {
    var aborts: Bool { get }
}

public protocol TreeTraversing {
    associatedtype Disposition: TreeTraversingDisposition
    associatedtype Node: TreeNode
    func traverse(node: Node, visitor: (Node) throws -> Disposition) rethrows -> Disposition
}

public extension TreeNode {
    
    var isLeaf: Bool { return children.isEmpty }
    
    @discardableResult
    public func traverse<T: TreeTraversing>(in order: T, visitor: (Self) throws -> T.Disposition) rethrows -> T.Disposition where T.Node == Self {
        return try order.traverse(node: self, visitor: visitor)
    }
    
    @discardableResult
    public func traverse(visitor: (Self) throws -> PreOrderTraversal<Self>.Disposition) rethrows -> PreOrderTraversal<Self>.Disposition {
        return try traverse(in: PreOrderTraversal(), visitor: visitor)
    }
    
}

public extension Collection where Element: TreeNode {
    
    public func traverseElements<T: TreeTraversing>(in order: T, visitor: (Element) throws -> T.Disposition) rethrows where T.Node == Element {
        for item in self {
            let d = try item.traverse(in: order, visitor: visitor)
            if d.aborts { return }
        }
    }
    
    public func traverseElements(visitor: (Element) throws -> PreOrderTraversal<Element>.Disposition) rethrows {
        try traverseElements(in: PreOrderTraversal(), visitor: visitor)
    }
    
}

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
    
    public func flatten<T: TreeTraversing>(in order: T, continuing: T.Disposition) -> Array<T.Node> where T.Node == Self {
        var flattened = Array<T.Node>()
        
        traverse(in: order) {
            flattened.append($0)
            return continuing
        }
        
        return flattened
    }
    
    public func flatten() -> Array<Self> {
        let order = PreOrderTraversal<Self>()
        return flatten(in: order, continuing: .continue)
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
    
    public func flatten<T: TreeTraversing>(in order: T, continuing: T.Disposition) -> Array<T.Node> where T.Node == Element {
        var flattened = Array<T.Node>()
        for node in self {
            node.traverse(in: order) {
                flattened.append($0)
                return continuing
            }
        }
        return flattened
    }
    
    public func flatten() -> Array<Element> {
        let order = PreOrderTraversal<Element>()
        return flatten(in: order, continuing: .continue)
    }
    
}

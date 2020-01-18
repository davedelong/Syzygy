//
//  Tree.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/21/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol TreeNode {
    var children: Array<Self> { get }
    var isLeaf: Bool { get }
}

public protocol TreeTraversingDisposition {
    static var keepGoing: Self { get }
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
    func traverse<T: TreeTraversing>(in order: T, visitor: (Self) throws -> T.Disposition) rethrows -> T.Disposition where T.Node == Self {
        return try order.traverse(node: self, visitor: visitor)
    }
    
    @discardableResult
    func traverse(visitor: (Self) throws -> PreOrderTraversal<Self>.Disposition) rethrows -> PreOrderTraversal<Self>.Disposition {
        return try traverse(in: PreOrderTraversal(), visitor: visitor)
    }
    
    func flatten<T: TreeTraversing>(in order: T) -> Array<T.Node> where T.Node == Self {
        var flattened = Array<T.Node>()
        
        traverse(in: order) {
            flattened.append($0)
            return T.Disposition.keepGoing
        }
        
        return flattened
    }
    
    func flatten() -> Array<Self> {
        return flatten(in: PreOrderTraversal())
    }
    
}

public extension Collection where Element: TreeNode {
    
    func traverseElements<T: TreeTraversing>(in order: T, visitor: (Element) throws -> T.Disposition) rethrows where T.Node == Element {
        for item in self {
            let d = try item.traverse(in: order, visitor: visitor)
            if d.aborts { return }
        }
    }
    
    func traverseElements(visitor: (Element) throws -> PreOrderTraversal<Element>.Disposition) rethrows {
        try traverseElements(in: PreOrderTraversal(), visitor: visitor)
    }
    
    func flatten<T: TreeTraversing>(in order: T) -> Array<T.Node> where T.Node == Element {
        var flattened = Array<T.Node>()
        for node in self {
            node.traverse(in: order) {
                flattened.append($0)
                return T.Disposition.keepGoing
            }
        }
        return flattened
    }
    
    func flatten() -> Array<Element> {
        return flatten(in: PreOrderTraversal())
    }
    
}

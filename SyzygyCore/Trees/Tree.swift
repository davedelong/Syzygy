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
        return try traverseElements(in: PreOrderTraversal(), visitor: visitor)
    }
    
}

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

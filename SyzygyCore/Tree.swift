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
    var isAbort: Bool { get }
}

public protocol TreeTraversing {
    associatedtype Disposition: TreeTraversingDisposition
    func traverse<T: TreeNode>(node: T, visitor: (T) throws -> Disposition) rethrows -> Disposition
}

public extension TreeNode {
    
    var isLeaf: Bool { return children.isEmpty }
    
    @discardableResult
    public func traverse<T: TreeTraversing>(in order: T, visitor: (Self) throws -> T.Disposition) rethrows -> T.Disposition {
        return try order.traverse(node: self, visitor: visitor)
    }
    
    @discardableResult
    public func traverse(visitor: (Self) throws -> PreOrderTraversal.Disposition) rethrows -> PreOrderTraversal.Disposition {
        return try traverse(in: PreOrderTraversal(), visitor: visitor)
    }
    
}

public extension Collection where Element: TreeNode {
    
    public func traverseElements<T: TreeTraversing>(in order: T, visitor: (Element) throws -> T.Disposition) rethrows {
        for item in self {
            let d = try item.traverse(in: order, visitor: visitor)
            if d.isAbort { return }
        }
    }
    
    public func traverseElements(visitor: (Element) throws -> PreOrderTraversal.Disposition) rethrows {
        return try traverseElements(in: PreOrderTraversal(), visitor: visitor)
    }
    
}

public struct PreOrderTraversal: TreeTraversing {
    
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
        case skipChildren
        public var isAbort: Bool { return self == .abort }
    }
    
    public init() { }
    
    public func traverse<T>(node: T, visitor: (T) throws -> PreOrderTraversal.Disposition) rethrows -> PreOrderTraversal.Disposition where T : TreeNode {
        let d = try visitor(node)
        if d.isAbort { return d }
        
        if d != .skipChildren {
            for child in node.children {
                let nodeD = try traverse(node: child, visitor: visitor)
                if nodeD.isAbort { return nodeD }
            }
        }
        return .continue
    }
    
}

public struct PostOrderTraversal: TreeTraversing {
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
        public var isAbort: Bool { return self == .abort }
    }
    
    public init() { }
    
    public func traverse<T>(node: T, visitor: (T) throws -> PostOrderTraversal.Disposition) rethrows -> PostOrderTraversal.Disposition where T : TreeNode {
        for child in node.children {
            let nodeD = try traverse(node: child, visitor: visitor)
            if nodeD.isAbort { return nodeD }
        }
        
        return try visitor(node)
    }
}

public struct BreadthFirstTreeTraversal: TreeTraversing {
    public enum Disposition: TreeTraversingDisposition {
        case abort
        case `continue`
        case skipChildren
        public var isAbort: Bool { return self == .abort }
    }
    
    public func traverse<T>(node: T, visitor: (T) throws -> BreadthFirstTreeTraversal.Disposition) rethrows -> BreadthFirstTreeTraversal.Disposition where T : TreeNode {
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

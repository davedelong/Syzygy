//
//  RelativePath.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public struct RelativePath: Path {
    public let components: Array<PathComponent>
    
    public var fileSystemPath: String {
        return components.map { $0.asString }.joined(separator: PathSeparator)
    }
    
    public init(_ pieces: String...) {
        let components = pieces.filter { $0 != PathSeparator }.map { PathComponent($0) }
        self.init(components)
    }
    
    public init(_ components: Array<PathComponent> = []) {
        self.components = reduce(components, allowRelative: true)
    }
    
    public func resolve(against: AbsolutePath) -> AbsolutePath {
        return AbsolutePath(against.components + components)
    }
}

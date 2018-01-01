//
//  Either.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public enum Either<T, U> {
    case left(T)
    case right(U)
    
    public var isLeft: Bool { return left != nil }
    public var isRight: Bool { return right != nil }
    
    public var left: T? {
        if case .left(let l) = self { return l }
        return nil
    }
    
    public var right: U? {
        if case .right(let r) = self { return r }
        return nil
    }
    
    public func mapLeft<A>(_ map: (T) -> A) -> Either<A, U> {
        switch self {
            case .left(let l): return .left(map(l))
            case .right(let r): return .right(r)
        }
    }
    
    public func mapRight<B>(_ map: (U) -> B) -> Either<T, B> {
        switch self {
            case .left(let l): return .left(l)
            case .right(let r): return .right(map(r))
        }
    }
}

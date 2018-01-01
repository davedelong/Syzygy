//
//  Bag.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public class Bag<T> {
    var _map = Dictionary<UUID, T>()
    var _list = Array<UUID>()
    
    public init() { }
    
    public func add(_ item: T) -> UUID {
        let uuid = UUID()
        _list.append(uuid)
        _map[uuid] = item
        return uuid
    }
    
    public func remove(_ uuid: UUID) {
        _map[uuid] = nil
        if let idx = _list.index(of: uuid) {
            _list.remove(at: idx)
        }
    }
    
    public func list() -> Array<T> {
        var l = Array<T>()
        for uuid in _list {
            if let o = _map[uuid] {
                l.append(o)
            }
        }
        return l
    }
}

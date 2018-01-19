//
//  UITableView+Diffs.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/2/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

#if os(iOS)

public extension UITableView {
    
    public func performDiffs<T>(_ diffs: Array<Diff<T>>) {
        performBatchUpdates({
            var deletes = Array<IndexPath>()
            var inserts = Array<IndexPath>()
            var moves = Array<(IndexPath, IndexPath)>()
            var reloads = Array<IndexPath>()
            
            for diff in diffs {
                switch diff {
                    case .delete(_, let r): deletes.append(IndexPath(row: r, section: 0))
                    case .insert(_, let r): inserts.append(IndexPath(row: r, section: 0))
                    case .move(_, let o, let n): moves.append((IndexPath(row: o, section: 0), IndexPath(row: n, section: 0)))
                    case .reload(_, let r): reloads.append(IndexPath(row: r, section: 0))
                    case .replace(_, let r): reloads.append(IndexPath(row: r, section: 0))
                }
            }
            
            if deletes.isEmpty == false { deleteRows(at: deletes, with: .top) }
            if inserts.isEmpty == false { insertRows(at: inserts, with: .top) }
            if moves.isEmpty == false { moves.forEach({ moveRow(at: $0, to: $1) }) }
            if reloads.isEmpty == false { reloadRows(at: reloads, with: .fade)}
            
        }, completion: nil)
    }
    
}

#endif

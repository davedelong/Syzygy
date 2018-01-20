//
//  NSCollectionView.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//
    
public extension NSCollectionView {
    
    func items<C: Collection>(at indexPaths: C) -> Array<NSCollectionViewItem> where C.Iterator.Element == IndexPath {
        var final = Array<NSCollectionViewItem>()
        
        let paths = Array(indexPaths)
        for path in paths {
            if let cvItem = item(at: path) {
                final.append(cvItem)
            }
        }
        
        return final
    }
    
}

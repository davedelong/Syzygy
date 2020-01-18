//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import UTI
import Paths

extension UTI {
    
    public var iconPath: AbsolutePath? {
        var utisToCheck = [self]
        var checked = Set<UTI>()
        
        while utisToCheck.isEmpty == false {
            let first = utisToCheck.removeFirst()
            guard checked.contains(first) == false else { continue }
            checked.insert(first)
            
            guard let thisBundle = first.declaringBundle else { continue }
            
            if let iconName = first.declaration.iconFile {
                let url = thisBundle.url(forResource: iconName, withExtension: nil) ??
                    thisBundle.url(forResource: iconName, withExtension: "icns")
                return url.map { AbsolutePath($0) }
            } else if let iconPath = first.declaration.iconPath {
                return thisBundle.path.appending(path: RelativePath(path: iconPath))
            }
            
            utisToCheck.append(contentsOf: first.declaration.conformsTo)
        }
        
        return nil
    }
    
}

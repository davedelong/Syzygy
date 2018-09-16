//
//  UIPasteboard.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/15/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

public extension UIPasteboard {
    
    subscript(key: UTI) -> Any? {
        get {
            return self.value(forPasteboardType: key.rawValue)
        }
        set {
            guard let value = newValue else { return }
            self.setValue(value, forPasteboardType: key.rawValue)
        }
        
    }
    
}

//
//  File.swift
//  
//
//  Created by Dave DeLong on 8/29/20.
//

import SwiftUI

extension View {
    
    public func isHidden(_ hidden: Bool) -> some View {
        Group {
            if hidden {
                self.hidden()
            } else {
                self
            }
        }
    }
    
    public func isVisible(_ visible: Bool) -> some View {
        isHidden(!visible)
    }
    
}

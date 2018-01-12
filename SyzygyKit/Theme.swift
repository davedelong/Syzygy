//
//  Theme.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/3/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import SyzygyCore

public struct Theme {
    
    // http://paletton.com/#uid=14u0u0kllllaFw0g0qFqFg0w0aF
    public let primaryColor = MutableProperty(Color(hexString: "4C2D73")!)
    
    public let lighterPrimaryColor = MutableProperty(Color(hexString: "6B4E90")!)
    public let lightestPrimaryColor = MutableProperty(Color(hexString: "8F78AD")!)
    
    public let darkerPrimaryColor = MutableProperty(Color(hexString: "321456")!)
    public let darkestPrimaryColor = MutableProperty(Color(hexString: "1C053A")!)
    
}

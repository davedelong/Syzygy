//
//  Measurement.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Measurement where UnitType == UnitVolume {
    
    public init(milliliters: Double, allowUSUnits: Bool = true) {
        let floz = milliliters / 29.5735296
        let gal = milliliters / 3785.411784
        
        if allowUSUnits && abs(round(floz) - floz) < 0.01 {
            self.init(value: round(floz), unit: .fluidOunces)
            
        } else if allowUSUnits && abs(round(gal) - gal) < 0.01 {
            self.init(value: round(gal), unit: .gallons)
            
        } else if milliliters >= 1000 {
            self.init(value: milliliters / 1000, unit: .liters)
            
        } else {
            self.init(value: milliliters, unit: .milliliters)
        }
        
    }
    
}

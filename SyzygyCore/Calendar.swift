//
//  Calendar.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/14/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension Calendar {
    
    public enum Gregorian {
        
        public enum Weekday: Int {
            public static func ==(lhs: Int, rhs: Weekday) -> Bool { return lhs == rhs.rawValue }
            public static func ==(lhs: Weekday, rhs: Int) -> Bool { return lhs.rawValue == rhs }
            
            case sunday = 1
            case monday = 2
            case tuesday = 3
            case wednesdsay = 4
            case thursday = 5
            case friday = 6
            case saturday = 7
        }
        
    }
    
    func daysInWeek(containing: Date) -> Array<Date> {
        let weekday = component(.weekday, from: containing)
        let calendricalStartOfWeek = self.firstWeekday
        
        let difference = abs(weekday - calendricalStartOfWeek)
        
        let startOfWeek = date(byAdding: .day, value: -difference, to: containing) !! "Can't find start of week for \(containing)"
        
        var days = Array<DateInterval>()
        for i in 0 ..< 7 {
            let dayOfWeek = date(byAdding: .day, value: i, to: startOfWeek) !! "Can't add \(i) days to \(startOfWeek)"
            let range = dateInterval(of: .day, for: dayOfWeek) !! "Can't find range of day containing \(dayOfWeek)"
            days.append(range)
        }
        
        return days.map { $0.mid }
    }
    
}

//
//  Extensions.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/19/22.
//

import Foundation

extension Date {
    
    // Proudly stolen from https://stackoverflow.com/questions/35771506/is-there-a-date-only-no-time-class-in-swift-or-foundation-classes/51638443
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    // Proudly stolen from https://stackoverflow.com/questions/25533147/get-day-of-week-using-nsdate
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
}

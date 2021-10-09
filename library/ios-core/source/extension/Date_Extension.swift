/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension Date {
    
    static func date(_ calendar : Calendar = Calendar(identifier: .gregorian), year : Int, month : Int, day : Int, hour : Int = 0, minute : Int = 0, second : Int = 0, zone : TimeZone = TimeZone.current) -> Date? {
        var component = DateComponents()
        component.year = year
        component.month = month
        component.day = day
        component.hour = hour
        component.minute = minute
        component.second = second
        component.timeZone = zone
        return calendar.date(from: component)
    }
    
    func getComponents(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> (year : Int, month : Int, day : Int, hour : Int, minute : Int, second : Int, zone : TimeZone) {
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second, .timeZone], from: self)
        let month = components.month
        let year = components.year
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let zone = components.timeZone
        return (year!, month!, day!, hour! , minute!, second!, zone!)
    }
    
    func getDayMonthYear(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> (day : Int, month : Int, year : Int) {
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let month = components.month
        let year = components.year
        let day = components.day
        return (day!, month!, year!)
    }
    
    func getMonthString(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> String {
        let weekday = calendar.component(.month, from: self)
        return calendar.monthSymbols[weekday-1]
    }
    
    func getWeekdayString(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> String {
        let weekday = calendar.component(.weekday, from: self)
        return calendar.weekdaySymbols[weekday-1]
    }
    
}

public extension Date {
    
    func dateByAdd(_ calendar : Calendar = Calendar(identifier: .gregorian), year : Int? = nil, month : Int? = nil, day : Int? = nil, hour : Int? = nil, minute : Int? = nil, second : Int? = nil) -> Date? {
        var component = DateComponents()
        component.day = day
        component.month = month
        component.year = year
        component.day = day
        component.minute = minute
        component.second = second
        return calendar.date(byAdding: component, to: self)
    }
    
    func firstDayOfThisMonth(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let month = components.month
        let year = components.year
        return Date.date(calendar, year: year!, month: month!, day: 1)!
    }
    
    func getDayOfWeek(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Int {
        return calendar.component(.weekday, from: self)
    }
    
    func lastMonth(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        return dateByAdd(calendar, month: -1)!
    }
    
    func nextMonth(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        return dateByAdd(calendar, month: 1)!
    }
    
    func yesterday(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        return dateByAdd(calendar, day: -1)!
    }
    
    func tomorrow(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        return dateByAdd(calendar, day: 1)!
    }
    
    func endDayOfThisMonth(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        return firstDayOfThisMonth(calendar).nextMonth(calendar).yesterday(calendar)
    }
    
    func beginDate(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        let component = getDayMonthYear(calendar)
        return Date.date(calendar, year: component.year, month: component.month, day: component.day)!
    }
    
    func endDate(_ calendar : Calendar = Calendar(identifier: .gregorian)) -> Date {
        return beginDate(calendar).addingTimeInterval(3600*24 - 1)
    }
    
}

public extension Date {
    
    func yearOld() -> Int {
        return Date().getDayMonthYear().year - getDayMonthYear().year
    }
    
}

public extension Date {
    
    static func isLeapYear(_ year : Int) -> Bool {
        return year % 4 == 0 && ((year % 100 != 0) || (year % 400 == 0))
    }
    
    static func numberOfDayIn(_ calendar : Calendar = Calendar(identifier: .gregorian), month : Int, year : Int) -> Int {
        let date = Date.date(calendar, year: year, month: month, day: 1)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    static func shortMonthSymbols (_ calendar : Calendar = Calendar(identifier: .gregorian)) -> [String] {
        return calendar.shortMonthSymbols
    }
    
    static func monthSymbols (_ calendar : Calendar = Calendar(identifier: .gregorian)) -> [String] {
        return calendar.monthSymbols
    }
    
}

public extension Date {
    
    static func dateFrom(_ calendar : Calendar = Calendar(identifier: .gregorian), date : Date!, time: Date!, ignoreSecond : Bool = true) -> Date {
        
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        let month = components.month
        let year = components.year
        let day = components.day
        components = calendar.dateComponents([.hour, .minute, .second], from: time)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        if !ignoreSecond {
            components.second = second
        } else {
            components.second = 0
        }
        
        return calendar.date(from: components)!
    }
    
    func isSameDayAs(_ date : Date) -> Bool {
        let d = getDayMonthYear()
        let s = date.getDayMonthYear()
        return d.day == s.day && d.month == s.month && d.year == s.year
    }
    
}

extension DateFormatter {
    
    static func create(_ calendar: Calendar.Identifier = .gregorian, format : String, locale: String? = nil, timezone: Int? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: calendar)
        if let locale = locale {
            formatter.locale = Locale(identifier: locale)
        }
        formatter.dateFormat = format
        if let timezone = timezone {
            formatter.timeZone = TimeZone.init(secondsFromGMT: timezone)
        }
        return formatter
    }
    
}

public extension Date {
    
    func toString(_ format : String = "yyyy-MM-dd'T'HH:mm:ssZZZ", locale: String? = nil, timezone: Int? = nil) -> String {
        let formatter = DateFormatter.create(format: format, locale: locale, timezone: timezone)
        return formatter.string(from: self)
    }
    
    static func date(_ str : String, format : String = "yyyy-MM-dd'T'HH:mm:ssZZZ", locale: String? = nil, timezone: Int? = nil) -> Date? {
        let formatter = DateFormatter.create(format: format, locale: locale, timezone: timezone)
        return formatter.date(from: str)
    }
    
    func toGMTString(_ format : String = "yyyy-MM-dd'T'HH:mm:ss", locale: String? = nil) -> String {
        let formatter = DateFormatter.create(format: format, locale: locale, timezone: 0)
        return formatter.string(from: self)
    }
    
    static func dateGMT(_ str : String, format : String = "yyyy-MM-dd'T'HH:mm:ss", locale: String? = nil) -> Date? {
        let formatter = DateFormatter.create(format: format, locale: locale, timezone: 0)
        return formatter.date(from: str)
    }
    
}

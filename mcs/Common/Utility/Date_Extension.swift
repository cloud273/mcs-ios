/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit
import QDCore

extension Date {
    
    // Month year format
    static func appMonthYearFormat() -> String {
        return "MM-yyyy"
    }
    
    func toAppMonthYearString() -> String {
        return toString(Date.appMonthYearFormat(), locale: McsDatabase.instance.language.rawValue)
    }
    
    // Datetime format
    static func appDateTimeFormat() -> String {
        return "dd-MM-yyyy hh:mm a"
    }
    
    func toAppDateTimeString() -> String {
        return toString(Date.appDateTimeFormat(), locale: McsDatabase.instance.language.rawValue)
    }
    
    // Date format
    static func appDateFormat() -> String {
        return "dd-MM-yyyy"
    }
    
    func toAppDateString() -> String {
        return toString(Date.appDateFormat(), locale: McsDatabase.instance.language.rawValue)
    }
    
    // Time format
    static func appTimeFormat() -> String {
        return "hh:mm a"
    }
    
    func toAppTimeString() -> String {
        return toString(Date.appTimeFormat(), locale: McsDatabase.instance.language.rawValue)
    }
    
    // Other format
    static func dateAppTimeFormat(_ timeString: String /*HH:mm:ss*/, timezone: String/*"+00:00"*/) -> Date? {
        return date("\("2000-01-01")T\(timeString)\(timezone)", format: "yyyy-MM-dd'T'HH:mm:ssZ", locale: "en_US_POSIX")
    }
    
}

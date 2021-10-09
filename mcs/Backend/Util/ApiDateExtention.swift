/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit
import QDCore

extension Date {
    
    // Datetime format
    static func apiDateTimeFormat() -> String {
        return "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    func toApiDateTimeString() -> String {
        let string =  toGMTString(Date.apiDateTimeFormat(), locale: "en_US_POSIX")
        let b = string.prefix(string.count - 2)
        let a = string.substring(from: string.count - 2)
        return "\(b):\(a)"
    }
    
    static func dateApiDateTimeFormat(_ str : String) -> Date? {
        return dateGMT(str, format: apiDateTimeFormat(), locale: "en_US_POSIX")
    }
    
    // Date format
    static func apiDateFormat() -> String {
        return "yyyy-MM-dd"
    }
    
    func toApiDateString() -> String {
        return toString(Date.apiDateFormat(), locale: "en_US_POSIX")
    }
    
    static func dateApiDateFormat(_ str : String) -> Date? {
        return date(str, format: apiDateFormat(), locale: "en_US_POSIX")
    }
    
    // Time format
    static func timeApiFormat() -> String {
        return "HH:mm:ss"
    }
    
    func toTimeApiString() -> String {
        return toString(Date.timeApiFormat(), locale: "en_US_POSIX")
    }
    
}



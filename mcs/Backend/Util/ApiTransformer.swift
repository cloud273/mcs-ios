/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import ObjectMapper

class DayTransform: TransformType {
    
    public typealias Object = Date
    public typealias JSON = String
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let text = value as? String {
            return Date.dateApiDateFormat(text)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        if let obj = value {
            return obj.toApiDateString()
        }
        return nil
    }
}

class DateTimeTransform: TransformType {
    
    public typealias Object = Date
    public typealias JSON = String
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let text = value as? String {
            return Date.dateApiDateTimeFormat(text)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        if let obj = value {
            return obj.toApiDateTimeString()
        }
        return nil
    }
}


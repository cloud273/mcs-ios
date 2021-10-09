/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension String {
    
    static func currency(_ value: Any, locale: String = "en_US") -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.init(identifier: locale)
        return formatter.string(for: value)
    }
    
    static func decimal(_ value: Any, locale: String = "en_US") -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.init(identifier: locale)
        return formatter.string(for: value)
    }
    
}

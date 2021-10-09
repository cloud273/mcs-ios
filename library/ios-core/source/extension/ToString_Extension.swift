/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension Bool {
    
    func toString() -> String {
        if self {
            return "true"
        } else {
            return "false"
        }
    }
    
}

public extension Int {
    
    func toString() -> String {
        return String(self)
    }
    
}

public extension Float {
    
    func toString(_ charAfterDot: Int = 2) -> String {
        let format = "%0." + charAfterDot.toString() + "f"
        return String.init(format: format, self)
    }
    
}

public extension Double {
    
    func toString(_ charAfterDot: Int = 2) -> String {
        let format = "%0." + charAfterDot.toString() + "f"
        return String.init(format: format, self)
    }
    
}

/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension Array where Element : Any {
    
    func toString() -> String? {
        var result : String? = nil
        if let _ = self.first as? String {
            result = ""
            for str in self {
                if result!.count > 0 {
                    result! += ", "
                }
                result! += str as! String
            }
        } else {
            if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
                result = String.init(data: data, encoding: .utf8)
            }
        }
        return result
    }
    
    func toJsonString() -> String? {
        var result : String? = nil
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            result = String.init(data: data, encoding: .utf8)
        }
        return result
    }
    
}




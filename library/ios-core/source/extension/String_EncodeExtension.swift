/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension String {
    
    func encodeQuery() -> String {
        let encodeString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let result = encodeString?.replacingOccurrences(of: "+", with: "%2B")
        return result!
    }
    
    func base64Encode() -> String {
        return self.data(using: .utf8)!.base64EncodedString()
    }
    
}

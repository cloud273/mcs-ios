/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension String {
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self.suffix(from: fromIndex))
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self.prefix(upTo: toIndex))
    }

    func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func substring(with range: NSRange) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
}

public extension String {
    
    func getHeight(_ width : CGFloat, font:UIFont) -> CGFloat {
        var result : CGFloat = 0
        if self.count > 0 {
            let text = self as NSString
            let w : CGFloat = CGFloat(width)
            let maxW = CGFloat(MAXFLOAT)
            result = text.boundingRect(with: CGSize(width: w, height: maxW), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.height
        }
        return result
    }
}

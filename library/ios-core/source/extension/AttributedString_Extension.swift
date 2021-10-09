/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension NSAttributedString {
    
    convenience init(_ string: String, font: UIFont? = nil, color: UIColor? = nil, aligment: NSTextAlignment? = nil, strike: Bool = false, underline: Bool = false) {
        var attributes = [NSAttributedString.Key : Any]()
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        if let aligment = aligment {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = aligment
            attributes[NSAttributedString.Key.paragraphStyle] = paragraph
        }
        if let color = color {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        if strike {
            attributes[NSAttributedString.Key.strikethroughStyle] = 1
            if let color = color {
                attributes[NSAttributedString.Key.strikethroughColor] = color
            }
        }
        if underline {
            attributes[NSAttributedString.Key.underlineStyle] = 1
            if let color = color {
                attributes[NSAttributedString.Key.underlineColor] = color
            }
        }
        self.init(string : string, attributes : attributes)
    }
    
    convenience init(_ image : UIImage, bounds: CGRect?) {
        let attachment = NSTextAttachment()
        attachment.image = image
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        self.init(attachment: attachment)
    }
}

public extension NSAttributedString {
    
    func getHeight(_ width : CGFloat) -> CGFloat {
        var result : CGFloat = 0
        if self.string.count > 0 {
            let w : CGFloat = CGFloat(width)
            let maxH = CGFloat(MAXFLOAT)
            result = self.boundingRect(with: CGSize(width: w, height: maxH), options: .usesLineFragmentOrigin, context: nil).height
        }
        return result
    }
    
}

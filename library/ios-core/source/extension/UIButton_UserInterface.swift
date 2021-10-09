/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

@IBDesignable
public extension UIButton {
    
    @IBInspectable
    var imageContentMode :Int {
        
        set {
            imageView?.contentMode = UIView.ContentMode(rawValue: newValue)!
        }
        
        get {
            let value = imageView?.contentMode.rawValue
            return value == nil ? 0 : value!
        }
        
    }
    
    @IBInspectable
    var titleMinimumScaleFactor : CGFloat {
        
        set {
            titleLabel?.adjustsFontSizeToFitWidth = true
            titleLabel?.minimumScaleFactor = newValue
        }
        
        get {
            let value = titleLabel?.minimumScaleFactor
            return value == nil ? 1 : value!
        }
    }
    
    @IBInspectable
    var titleNumberOfLine : Int {
        
        set {
            titleLabel?.numberOfLines = newValue
        }
        
        get {
            let value = titleLabel?.numberOfLines
            return value == nil ? 0 : value!
        }
    }
}


/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

@IBDesignable
public extension UIView {
    
    @IBInspectable
    var cornerRadius :CGFloat {
        
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
        
    }
    
    @IBInspectable
    var borderWidth :CGFloat {
        
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
        
    }
    
    @IBInspectable
    var borderColor :UIColor? {
        
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            if layer.borderColor == nil {
                return nil
            } else {
                return UIColor(cgColor: layer.borderColor!)
            }
        }
    }
    
//    @IBInspectable
//    var bgSOpacity :Float {
//        
//        set {
//            layer.shadowOpacity = newValue
//        }
//        
//        get {
//            return layer.shadowOpacity
//        }
//    }
//    
//    @IBInspectable
//    var bgSColor :UIColor? {
//        
//        set {
//            layer.shadowColor = newValue?.cgColor
//        }
//        
//        get {
//            if layer.shadowColor == nil {
//                return nil
//            } else {
//                return UIColor(cgColor: layer.shadowColor!)
//            }
//        }
//    }
//    
//    @IBInspectable
//    var bgSRadius :CGFloat {
//        
//        set {
//            layer.shadowRadius = newValue
//        }
//        
//        get {
//            return layer.shadowRadius
//        }
//    }
//    
//    @IBInspectable
//    var bgSOffset :CGSize {
//        
//        set {
//            layer.shadowOffset = newValue
//        }
//        
//        get {
//            return layer.shadowOffset
//        }
//    }
    
}

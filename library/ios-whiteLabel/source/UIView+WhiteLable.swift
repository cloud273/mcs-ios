/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

public extension UIView {
    
    @IBInspectable
    var wTintColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor  {
                self.tintColor = color
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wBgColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor  {
                self.backgroundColor = color
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wBorderBgColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor {
                self.layer.borderColor = color.cgColor
            }
        }
        get {
            return nil
        }
    }
    
}

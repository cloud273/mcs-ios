/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

public extension UIBarItem {
    
    @IBInspectable
    var wFont: String? {
        set {
            if let v = newValue, let font = v.whiteLabelFont {
                self.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor {
                self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
            }
        }
        get {
            return nil
        }
    }
    
}

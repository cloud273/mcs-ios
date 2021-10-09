/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension UILabel {
    
    @IBInspectable
    var wFont: String? {
        set {
            if let v = newValue, let font = v.whiteLabelFont {
                self.font = font
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
                self.textColor = color
            }
        }
        get {
            return nil
        }
    }
    
}

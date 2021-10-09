/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

private var highlightedBackgroundColor: UInt8 = 0

public extension UIButton {
    
    @IBInspectable
    var wFont: String? {
        set {
            if let v = newValue, let font = v.whiteLabelFont {
                self.titleLabel!.font = font
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
                self.setTitleColor(color, for: .normal)
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wHighlightedBgColor: String? {
        set {
            if let v = newValue {
                objc_setAssociatedObject(self, &highlightedBackgroundColor, v, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            return objc_getAssociatedObject(self, &highlightedBackgroundColor) as? String
        }
    }
    
}

extension UIButton {
    
    open override var isHighlighted: Bool {
        didSet {
            if let highlightColor = self.wHighlightedBgColor, let normalColor = self.wBgColor {
                backgroundColor = isHighlighted ? highlightColor.whiteLabelColor : normalColor.whiteLabelColor
            }
        }
    }
    
}

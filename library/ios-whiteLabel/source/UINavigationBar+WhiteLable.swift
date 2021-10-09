/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

public extension UINavigationBar {
    
    @IBInspectable
    var wBarTintColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor  {
                barTintColor = color
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wTitleFont: String? {
        set {
            if let v = newValue, let font = v.whiteLabelFont {
                var attributed = titleTextAttributes
                if attributed == nil {
                    attributed = [:]
                }
                attributed![NSAttributedString.Key.font] = font
                titleTextAttributes = attributed
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wTitleColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor {
                var attributed = titleTextAttributes
                if attributed == nil {
                    attributed = [:]
                }
                attributed![NSAttributedString.Key.foregroundColor] = color
                titleTextAttributes = attributed
            }
        }
        get {
            return nil
        }
    }
    
}

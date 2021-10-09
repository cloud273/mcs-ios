/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

public extension UISegmentedControl {
    
    @IBInspectable
    var wNormalColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor  {
                var attributed = titleTextAttributes(for: .normal)
                if attributed == nil {
                    attributed = [:]
                }
                attributed![NSAttributedString.Key.foregroundColor] = color
                setTitleTextAttributes(attributed, for: .normal)
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wNormalFont: String? {
        set {
            if let v = newValue, let font = v.whiteLabelFont {
                var attributed = titleTextAttributes(for: .normal)
                if attributed == nil {
                    attributed = [:]
                }
                attributed![NSAttributedString.Key.font] = font
                setTitleTextAttributes(attributed, for: .normal)
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wSelectedColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor  {
                var attributed = titleTextAttributes(for: .selected)
                if attributed == nil {
                    attributed = [:]
                }
                attributed![NSAttributedString.Key.foregroundColor] = color
                setTitleTextAttributes(attributed, for: .selected)
            }
        }
        get {
            return nil
        }
    }
    
    @IBInspectable
    var wSelectedFont: String? {
        set {
            if let v = newValue, let font = v.whiteLabelFont {
                var attributed = titleTextAttributes(for: .selected)
                if attributed == nil {
                    attributed = [:]
                }
                attributed![NSAttributedString.Key.font] = font
                setTitleTextAttributes(attributed, for: .selected)
            }
        }
        get {
            return nil
        }
    }
    
}

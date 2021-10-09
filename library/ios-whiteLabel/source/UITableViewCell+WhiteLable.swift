/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

public extension UITableViewCell {
    
    @IBInspectable
    var wHighlightedBgColor: String? {
        set {
            if let v = newValue, let color = v.whiteLabelColor {
                let view = UIView.init()
                view.backgroundColor = color
                selectedBackgroundView = view
            }
        }
        get {
            return nil
        }
    }
    
}

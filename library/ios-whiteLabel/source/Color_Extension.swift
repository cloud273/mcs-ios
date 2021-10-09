/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 0xFF, green: CGFloat(g) / 0xFF, blue: CGFloat(b) / 0xFF, alpha: a)
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(r: (rgb >> 16) & 0xFF, g: (rgb >> 8) & 0xFF, b: rgb & 0xFF, a: a)
    }
    
}


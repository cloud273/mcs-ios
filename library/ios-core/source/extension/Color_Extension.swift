/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension UIColor {
    
    static let button: UIColor = UIColor.init(rgb: 0x007AFF)
    
    func blurColor() -> UIColor {
        let ciColor = CIColor.init(color: self)
        return UIColor.init(red: max(0, min(ciColor.red * 1.2, 1)), green: max(0, min(ciColor.green * 1.2, 1)), blue: max (0, min(ciColor.blue * 1.2, 1)), alpha: ciColor.alpha)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 0xFF, green: CGFloat(g) / 0xFF, blue: CGFloat(b) / 0xFF, alpha: a)
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(r: (rgb >> 16) & 0xFF, g: (rgb >> 8) & 0xFF, b: rgb & 0xFF, a: a)
    }
    
}

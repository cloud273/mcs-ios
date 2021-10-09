/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension UIFont {
    
    func withTraits(_ size: CGFloat?, traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: size ?? 0)
    }
    
}

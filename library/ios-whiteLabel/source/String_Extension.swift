/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension String {
    
    var whiteLabelFont: UIFont? {
        get {
            return QDWhiteLabel.getFont(self)
        }
    }
    
    var whiteLabelColor: UIColor? {
        get {
            return QDWhiteLabel.getColor(self)
        }
    }
    
}


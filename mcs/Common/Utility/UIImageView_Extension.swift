/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit
import Kingfisher

public extension UIImageView {
    
    func setImageUrl(_ url: String?, placeholder: UIImage?) {
        if let url = url {
            self.kf.setImage(with: URL.init(string: url), placeholder: placeholder)
        } else {
            self.image = placeholder
        }
    }
    
}




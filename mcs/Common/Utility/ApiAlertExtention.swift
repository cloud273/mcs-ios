/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit
import QDCore

public extension UIAlertController {
    
    static func generalErrorAlert(_ controller: UIViewController?) {
        self.show(controller, title: "Error".localized, message: "Backend_connect_fail_message".localized, close: "Close".localized)
    }
    
}



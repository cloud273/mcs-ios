/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension UIViewController {
    
    static func presentedViewController(_ ignoreAlertController: Bool = true) -> UIViewController? {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            return vc.presentedViewController()
        } else {
            return nil
        }
    }
    
    func presentedViewController(_ ignoreAlertController: Bool = true) -> UIViewController {
        var vc = self
        while true {
            if let tmp = vc.presentedViewController {
                if !ignoreAlertController, let _ = tmp as? UIAlertController {
                    break
                } else {
                    vc = tmp
                }
            } else {
                break
            }
        }
        return vc
    }

}

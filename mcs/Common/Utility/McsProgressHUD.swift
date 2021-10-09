/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/04.
*/

import UIKit
import ProgressHUD

class McsProgressHUD: NSObject {

    static func show(_ vc: UIViewController, text: String? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ProgressHUD.show(text)
    }
    
    static func show(_ view: UIView, text: String? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ProgressHUD.show(text)
    }
    
    static func hide(_ vc: UIViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        ProgressHUD.dismiss()
    }
    
    static func hide(_ view: UIView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        ProgressHUD.dismiss()
    }
}

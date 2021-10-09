/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public extension UIAlertController {

    static func show(_ controller : UIViewController? = nil, title : String?, message : String?, close : String = "Close") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: close, style: .cancel, handler: nil))
        let vc = controller ?? UIViewController.presentedViewController()!
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ controller : UIViewController? = nil, title : String?, message : String?, close : String = "Close", action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: close, style: .cancel, handler: { (_) in
            action()
        }))
        let vc = controller ?? UIViewController.presentedViewController()!
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ controller : UIViewController? = nil, title : String?, message : String?, no : String?, yes: String, action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: no, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: yes, style: .default, handler: { (_) in
            action()
        }))
        let vc = controller ?? UIViewController.presentedViewController()!
        vc.present(alert, animated: true, completion: nil)
    }
    
    func show(_ controller: UIViewController? = nil, from view: UIView? = nil) {
        let vc = controller ?? UIViewController.presentedViewController()!
        if self.preferredStyle == .actionSheet {
            if let view = view {
                self.popoverPresentationController?.sourceView = view
                self.popoverPresentationController?.sourceRect = view.bounds
            } else {
                self.popoverPresentationController?.permittedArrowDirections = .down
                self.popoverPresentationController?.sourceView = vc.view
                self.popoverPresentationController?.sourceRect = CGRect.init(x: vc.view.bounds.width/2, y: vc.view.bounds.height/2, width: 1, height: 1)
            }
        }
        vc.present(self, animated: true, completion: nil)
    }
    
}

/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit

class McsTextInputControllerRePassword: McsTextInputControllerDefault {
    
    private weak var passwordController: McsTextInputControllerPassword!
    
    convenience init(_ view: UIView, lPlaceHolder: String?, pastable: Bool, require: Bool, passwordController: McsTextInputControllerPassword, delegate: McsTextInputProtocol? = nil) {
        self.init(view, lPlaceHolder: lPlaceHolder, pastable: pastable, require: require, delegate: delegate)
        self.passwordController = passwordController
    }
    
    
    // MARK: ----------override----------
    
    override func setup() {
        super.setup()
        textField.isSecureTextEntry = true
    }

    override func getErrorForText() -> String? {
        if let text = value as? String, text.count > 0 {
            if text == (passwordController.value as? String) {
                return nil
            } else {
                return "Mismatch_password".localized
            }
        } else {
            return super.getErrorForText()
        }
    }
    
}

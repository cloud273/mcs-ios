/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit

class McsTextInputControllerPassword: McsTextInputControllerDefault {
    
    override func setup() {
        super.setup()
        textField.isSecureTextEntry = true
    }

    override func getErrorForText() -> String? {
        if let text = value as? String, text.count > 0 {
            if text.count < 6 {
                return "Too_short_password_message".localized
            } else {
                return nil
            }
        } else {
            return super.getErrorForText()
        }
    }
    
}

/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import MaterialComponents
import QDCore
import CLLocalization

class McsTextInputControllerEmail: McsTextInputControllerDefault {

    override func setup() {
        super.setup()
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        maxTextLength = 128
    }
    
    override func getErrorForText() -> String? {
        if let text = value as? String, text.count > 0 {
            if text.isValidateEmail() {
                return nil
            } else {
                return "Invalid_email".localized
            }
        } else {
            return super.getErrorForText()
        }
    }
    
}

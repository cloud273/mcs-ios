/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import PhoneNumberKit
import MaterialComponents
import QDCore
import CLLocalization

class McsTextInputControllerEmailPhone: McsTextInputControllerDefault {
    
    override func setup() {
        super.setup()
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        maxTextLength = 128
    }
    
    override func getErrorForText() -> String? {
        if let text = super.value as? String, text.count > 0 {
            if text.isValidateEmail() || text.isValidPhoneNumber() {
                return nil
            } else {
                return "Invalid_phone_email".localized
            }
        } else {
            return super.getErrorForText()
        }
    }
    
    override var value: Any? {
        get {
            if let text = super.value as? String, text.count > 0 {
                if text.isValidateEmail() {
                    return text
                } else if text.isValidPhoneNumber() {
                    return text.phoneNumber()
                }
            }
            return nil
        }
        set {
            super.value = newValue
        }
    }
    
}

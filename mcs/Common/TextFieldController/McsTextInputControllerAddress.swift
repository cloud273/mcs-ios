/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit

class McsTextInputControllerAddress: McsTextInputControllerDefault {
    
    override func setup() {
        super.setup()
        textField.autocapitalizationType = .words
        maxTextLength = 512
    }
    
    override func getErrorForText() -> String? {
        if let text = value as? String, text.count > 0 {
            if text.rangeOfCharacter(from: CharacterSet.letters) == nil || text.count < 2 {
                return "Invalid_address".localized
            } else {
                return nil
            }
        } else {
            return super.getErrorForText()
        }
    }
    
}


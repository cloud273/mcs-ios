/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/21.
*/

import UIKit

class McsTextInputControllerSurgery: McsTextInputControllerDefault {
    
    override func setup() {
        super.setup()
        textField.autocapitalizationType = .sentences
        maxTextLength = 128
    }
    
    override func getErrorForText() -> String? {
        if let text = value as? String, text.count > 0 {
            if text.rangeOfCharacter(from: CharacterSet.letters) == nil {
                return "Invalid".localized
            } else if text.count < 2 {
                return String.init(format: "Too_short_message".localized, 2)
            } else {
                return nil
            }
        } else {
            return super.getErrorForText()
        }
    }
    
}


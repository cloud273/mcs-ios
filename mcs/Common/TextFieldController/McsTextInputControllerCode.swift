/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/27.
*/

import UIKit

class McsTextInputControllerCode: McsTextInputControllerDefault {
    
    override func setup() {
        super.setup()
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        maxTextLength = 6
    }
    
}

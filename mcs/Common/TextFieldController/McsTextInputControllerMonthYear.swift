/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore
import MaterialComponents

class McsTextInputControllerMonthYear: McsTextInputControllerDate {
    
    // MARK: ----------override----------
    
    override func updateTextField() {
        self.textField.text = (value as? Date)?.toAppMonthYearString()
    }
    
    
}

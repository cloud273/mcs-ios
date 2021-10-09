/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore
import MaterialComponents

class McsTextInputControllerClearableTime: McsTextInputControllerDate {
    
    // MARK: ----------override----------
    
    override func clearButtonMode() -> UITextField.ViewMode {
        return .unlessEditing
    }
    
    override func datePickerMode() -> UIDatePicker.Mode {
        return .time
    }
    
    override func timeMinuteInterval() -> Int {
        return 15
    }
    
    override func updateTextField() {
        self.textField.text = (value as? Date)?.toAppTimeString()
    }
    
}

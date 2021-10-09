/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore
import MaterialComponents

class McsTextInputControllerDate: McsTextInputControllerCustomKeyboard {
    
    convenience init(_ view: UIView, lPlaceHolder: String?, minDate: Date? = nil, maxDate: Date? = nil, require: Bool, delegate: McsTextInputProtocol? = nil) {
        self.init(view, lPlaceHolder: lPlaceHolder, pastable: false, require: require, delegate: delegate)
        self.isRequire = require
         _ = super.createKeyboard(minDate: minDate, maxDate: maxDate, mode: datePickerMode(), minuteInterval: timeMinuteInterval(), locale: locale())
    }
    
    func datePickerMode() -> UIDatePicker.Mode {
        return .date
    }
    
    func timeMinuteInterval() -> Int {
        return 1
    }
    
    func locale() -> Locale? {
        return nil //Locale.init(identifier: McsDatabase.instance.language.rawValue)
    }
    
    // MARK: ----------override----------
    
    override func updateTextField() {
        self.textField.text = (value as? Date)?.toAppDateString()
    }
    
    override var value: Any? {
        get {
            return super.value
        }
        set {
            if newValue == nil {
                super.value = nil
            } else {
                if let date = newValue as? Date {
                    super.value = date
                } else {
                    fatalError("Input must be Date")
                }
            }
        }
    }
    
    override func createKeyboard(_ selected: String? = nil, options: [String], rowHeight: CGFloat = 30) -> QDSelectKeyboard {
        fatalError("Do not call this method")
    }
    
    override func createKeyboard(_ selected: QDKbTextProtocol? = nil, options: [QDKbTextProtocol], rowHeight: CGFloat = 30) -> QDSelectKeyboard {
        fatalError("Do not call this method")
    }
    
    override func createKeyboard(_ selected: QDKBObjectProtocol? = nil, options: [QDKBObjectProtocol], rowHeight: CGFloat = 30) -> QDSelectKeyboard {
        fatalError("Do not call this method")
    }
    
    override func createKeyboard(_ selected: Date? = nil, minDate: Date?, maxDate: Date?, mode: UIDatePicker.Mode, minuteInterval: Int, locale: Locale?) -> QDDateKeyboard {
        fatalError("Do not call this method")
    }
    
}

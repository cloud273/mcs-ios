/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore
import MaterialComponents

class McsTextInputControllerCity: McsTextInputControllerCustomKeyboard {
    
    private var state: McsState!
    
    convenience init(_ view: UIView, lPlaceHolder: String?, state: McsState, require: Bool, delegate: McsTextInputProtocol? = nil) {
        self.init(view, lPlaceHolder: lPlaceHolder, pastable: false, require: require, delegate: delegate)
        self.isRequire = require
        set(state)
    }
    
    func set(_ state: McsState) {
        if state.code != self.state?.code {
            self.state = state
            if let objs = state.cities, objs.count > 0 {
                _ = super.createKeyboard(nil, options: objs)
            } else {
                fatalError("Invalid stateCode \(state.code!)")
            }
        }
    }
    
    // MARK: ----------override----------
    
    override func updateTextField() {
        self.textField.text = (value as? McsCity)?.getText()
    }
    
    override var value: Any? {
        get {
            return super.value
        }
        set {
            if let data = newValue as? McsCity {
                super.value = data
            } else {
                fatalError("Input must be McsCity")
            }
        }
    }
    
    override func createKeyboard(_ selected: Date? = nil, minDate: Date?, maxDate: Date?, mode: UIDatePicker.Mode, minuteInterval: Int, locale: Locale?) -> QDDateKeyboard {
        fatalError("Do not call this method")
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
    
}


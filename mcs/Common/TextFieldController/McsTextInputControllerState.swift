/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore
import MaterialComponents

class McsTextInputControllerState: McsTextInputControllerCustomKeyboard {
    
    private var country: McsCountry!
    private var keyboard: QDSelectKeyboard!
    
    convenience init(_ view: UIView, lPlaceHolder: String?, country: McsCountry, require: Bool, delegate: McsTextInputProtocol? = nil) {
        self.init(view, lPlaceHolder: lPlaceHolder, pastable: false, require: require, delegate: delegate)
        self.isRequire = require
        set(country)
    }
    
    func set(_ country: McsCountry) {
        if country.code != self.country?.code {
            self.country = country
            if let objs = country.states, objs.count > 0 {
                _ = super.createKeyboard(nil, options: objs)
            } else {
                fatalError("Invalid countryCode \(country.code!)")
            }
        }
    }
    
    // MARK: ----------override----------
    
    override func updateTextField() {
        self.textField.text = (value as? McsState)?.getText()
    }
    
    override var value: Any? {
        get {
            return super.value
        }
        set {
            if let date = newValue as? McsState {
                super.value = date
            } else {
                fatalError("Input must be McsState")
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


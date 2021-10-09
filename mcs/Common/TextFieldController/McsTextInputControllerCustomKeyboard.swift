/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore
import MaterialComponents
import QDWhiteLabel


class McsTextInputControllerCustomKeyboard: McsTextInputControllerDefault {
    
    private var _keyboard: QDKeyboard?
    
    private var _options: [Any]?
    
    private var _value: Any?
    
    private func setupKeyboard(_ kb: QDKeyboard, selected: Any?, options: [Any]?) {
        _options = options
        _keyboard = kb
        setValue(selected)
    }
    
    private func setValue(_ value: Any?) {
        _value = value
        updateTextField()
    }
    
    func createKeyboard(_ selected: String? = nil, options: [String], rowHeight: CGFloat = 30) -> QDSelectKeyboard {
        let result = QDSelectKeyboard.init(self.textField, list: options, font: "medium-font".whiteLabelFont!, color: "black-color".whiteLabelColor!, rowHeight: rowHeight, delegate: self)
        result.wBgColor = "background"
        setupKeyboard(result, selected: selected, options: options)
        return result
    }
    
    func createKeyboard(_ selected: QDKbTextProtocol? = nil, options: [QDKbTextProtocol], rowHeight: CGFloat = 30) -> QDSelectKeyboard {
        let result = QDSelectKeyboard.init(self.textField, list: options, font: "medium-font".whiteLabelFont!, color: "black-color".whiteLabelColor!, rowHeight: rowHeight, delegate: self)
        result.wBgColor = "background"
        setupKeyboard(result, selected: selected, options: options)
        return result
    }
    
    func createKeyboard(_ selected: QDKBObjectProtocol? = nil, options: [QDKBObjectProtocol], rowHeight: CGFloat = 30) -> QDSelectKeyboard {
        let result = QDSelectKeyboard.init(self.textField, list: options, rowHeight: rowHeight, delegate: self)
        result.wBgColor = "background"
        setupKeyboard(result, selected: selected, options: options)
        return result
    }
    
    func createKeyboard(_ selected: Date? = nil, minDate: Date?, maxDate: Date?, mode: UIDatePicker.Mode, minuteInterval: Int, locale: Locale?) -> QDDateKeyboard {
        let result = QDDateKeyboard.init(self.textField, minDate: minDate, maxDate: maxDate, mode: mode, minuteInterval: minuteInterval, locale: locale, delegate: self)
        result.wBgColor = "background"
        result.textColor = "black-color".whiteLabelColor!
        setupKeyboard(result, selected: selected, options: nil)
        return result
    }
    
    // MARK: ----------subclass can override this method to convert obj to text that show on textfield----------
    override var value: Any? {
        get {
            return _value
        }
        set {
            setValue(newValue)
            if let v = _value {
                _keyboard?.select(v)
            }
        }
    }
    
    func updateTextField() {
        if let v = _value {
            if let obj = v as? QDKbTextProtocol {
                self.textField.text = obj.getText()
            } else if let obj = v as? QDKBObjectProtocol {
                self.textField.attributedText = obj.getAttributeText()
            } else if let obj = v as? String {
                self.textField.text = obj
            }
        } else {
            self.textField.text = ""
        }
    }
    
}

extension McsTextInputControllerCustomKeyboard: QDKeyboardProtocol {
    
    func keyboardSelected(_ keyboard: Any, value: Any?) {
        setValue(value)
        showErrorIfNeed()
        self.delegate?.valueChanged(self, value: self.value)
    }
    
}

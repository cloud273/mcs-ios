/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import MaterialComponents
import QDCore
import CLLocalization
import QDWhiteLabel

protocol McsTextInputProtocol: NSObjectProtocol {
    
    func valueChanged(_ controller: McsTextInputControllerDefault, value: Any?)
}

class McsTextInputControllerDefault: MDCTextInputControllerUnderline {
    
    private static let textDidChangeNotification = NSNotification.Name.init("__McsTextInputControllerDefault.textDidChangeNotification__")
    
    private var _customeErrorText: String?
    
    weak var delegate: McsTextInputProtocol?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func languageChanged() {
        if errorText != nil {
            showErrorIfNeed()
        }
    }
    
    @objc
    private func textFieldDidChanged(_ notification: Notification) {
        textDidChanged()
    }
    
    private func textDidChanged() {
        NotificationCenter.default.post(name: McsTextInputControllerDefault.textDidChangeNotification, object: self)
        delegate?.valueChanged(self, value: value)
        showErrorIfNeed()
    }
    
    private func privateErrorText() -> String? {
        if isUsingCustomErrorText {
            return customeErrorText
        } else {
            return getErrorForText()
        }
    }
    
    // MARK: ----------Protected method----------
    func setup() {
        textField.clearButtonMode = clearButtonMode()
        textField.autocorrectionType = autocorrectionType()
        textField.spellCheckingType = spellCheckingType()
        textField.returnKeyType = returnKeyType()
        
        underlineHeightActive = 0.5
        underlineHeightNormal = 0.5
        textInputFont = "normal-font".whiteLabelFont
        inlinePlaceholderColor = "lightgray-color".whiteLabelColor
        activeColor = "black-color".whiteLabelColor
        normalColor = "black-color".whiteLabelColor
        floatingPlaceholderActiveColor =  "black-color".whiteLabelColor!
        errorColor = "error-color".whiteLabelColor
    }
    
    func clearButtonMode() -> UITextField.ViewMode {
        return .never
    }
    
    func autocorrectionType() -> UITextAutocorrectionType {
        return .no
    }
    
    func spellCheckingType() -> UITextSpellCheckingType {
        return .no
    }
    
    func returnKeyType() -> UIReturnKeyType {
        return .done
    }
    
    func canChange(_ text: String) -> Bool {
        return true
    }
    
    func getErrorForText() -> String? {
        if isRequire {
            if value == nil {
                return "Required_asterisk".localized
            } else if let v = value as? String, v.isEmpty  {
                return "Required_asterisk".localized
            }
        }
        return nil
    }
    
    // MARK: ----------Proverty and public function----------
    convenience init(_ view: UIView, lPlaceHolder: String?, pastable: Bool, require: Bool, delegate: McsTextInputProtocol? = nil) {
        self.init()
        let input = McsTextField.create(view, lPlaceHolder: lPlaceHolder, pastable: pastable, delegate: self)
        self.textInput = input
        self.delegate = delegate
        self.isRequire = require
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChanged(_:)), name: UITextField.textDidChangeNotification, object: input)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: CLLocalization.languageChangedNotification, object: nil)
        self.setup()
    }
    
    var value: Any? {
        get {
            return textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        set {
            textField.text = newValue as? String
        }
    }
    
    final var textField: McsTextField {
        get {
            return self.textInput as! McsTextField
        }
    }
    
    final var isValid: Bool {
        get {
            return privateErrorText() == nil
        }
    }
    
    final var customeErrorText: String? {
        get {
            return _customeErrorText
        }
        set {
            _customeErrorText = newValue
            showErrorIfNeed()
        }
    }
    
    final var isUsingCustomErrorText: Bool = false
    
    final var isRequire: Bool = false
    
    final var maxTextLength: Int? = nil
    
    final func showErrorIfNeed() {
        self.setErrorText(privateErrorText(), errorAccessibilityValue: nil)
    }
    
    final func setupNavigateAccessoryKeyboard(prev: Bool, next: Bool, delegate: QDKbAccessoryProtocol) -> QDKbAccessory {
        let result = QDKbAccessory.init(self.textInput as? UITextField, delegate: delegate)!
        if prev {
            result.leftButton.setTitle(nil, for: .normal)
            result.leftButton.setImage(UIImage.init(named: "prev"), for: .normal)
            _ = result.leftButton.addAspectConstraint(1)
            _ = result.leftButton.addInnerEdgeConstraint(types: [.top], offset: 0)
            result.leftButton.isHidden = false
        } else {
            result.leftButton.isHidden = true
        }
        if next {
            result.rightButton.setTitle(nil, for: .normal)
            result.rightButton.setImage(UIImage.init(named: "next"), for: .normal)
            _ = result.rightButton.addAspectConstraint(1)
            _ = result.rightButton.addInnerEdgeConstraint(types: [.top], offset: 0)
            result.rightButton.isHidden = false
        } else {
            result.rightButton.isHidden = true
        }
        result.nameLabel.lText = "Hide"
        result.nameLabel.minimumScaleFactor = 0.7
        result.nameLabel.adjustsFontSizeToFitWidth = true
        result.nameLabel.textAlignment = .center
        result.nameLabel.addTapGestureRecognizer { [weak self] (_) in
            if let weakSelf = self {
                weakSelf.textInput?.resignFirstResponder()
            }
        }
        return result
    }
    
    final func setupDoneAccessoryKeyboard(delegate: QDKbAccessoryProtocol) -> QDKbAccessory {
        let result = QDKbAccessory.init(self.textInput as? UITextField, delegate: delegate)!
        result.leftButton.isHidden = true
        result.rightButton.lNormal = "Done"
        result.rightButton.isHidden = false
        result.nameLabel.text = nil
        return result
    }
    
}

extension McsTextInputControllerDefault: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldEndEditing")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing")
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        print("textFieldDidEndEditing:reason")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("textField:shouldChangeCharactersIn:replacementString")
        var result = true
        if let max = maxTextLength {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                result = updatedText.count <= max
            }
        }
        return result
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        print("textFieldShouldClear")
        value = nil
        textDidChanged()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("textFieldShouldReturn")
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}

/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*/

import UIKit

public class QDTextField: UITextField {

    @IBInspectable
    public var acceptCharacterInString :String?
    
    @IBInspectable
    public var format :String!
    
    private weak var originalDelegate: UITextFieldDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.delegate = self
    }
    
    var unformattedText: String? {
        get {
            return self.text?.unFormattedString(format, acceptedCharacter: acceptCharacterInString) ?? ""
        }
    }
    
}

extension QDTextField {
    
    override public var delegate: UITextFieldDelegate? {
        get {
            return originalDelegate
        }
        set {
            self.willChangeValue(forKey: "delegate")
            self.originalDelegate = newValue
            self.didChangeValue(forKey: "delegate")
        }
    }
    
    
    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let delegate = originalDelegate, delegate.responds(to: aSelector), !delegate.isEqual(self) {
            return self.originalDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    
    override public func responds(to aSelector: Selector!) -> Bool {
        var respondsToSelector = super.responds(to: aSelector)
        if !respondsToSelector, let delegate = originalDelegate, !delegate.isEqual(self) {
            respondsToSelector = delegate.responds(to: aSelector)
        }
        return respondsToSelector
    }
}

extension QDTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let textRange = Range.init(range, in: currentText)!
        let updateString = currentText.replacingCharacters(in: textRange, with: string)
        let newText = updateString.formattedString(format, acceptedCharacter: acceptCharacterInString)
        if updateString != newText {
            var newRange: NSRange
            var newReplacementString: String
            if currentText.count < newText.count {
                newReplacementString = newText.substring(from: currentText.count)
                newRange = NSMakeRange(currentText.count, 0)
            } else {
                newReplacementString = ""
                newRange = NSMakeRange(newText.count, currentText.count - newText.count)

            }
            var result: Bool = true
            if let delegate = originalDelegate, delegate.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) {
                result = delegate.textField!(textField, shouldChangeCharactersIn: newRange, replacementString: newReplacementString)
            }
            if result {
                super.text = newText
            }
            return false
        }
        return true
    }
    
}


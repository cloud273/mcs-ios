/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import UIKit

open class QDFormViewController: QDViewController {
    
    @IBOutlet weak public var scrollView: UIScrollView!
    
    public var inputFields = [UIView]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let sv = scrollView {
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.backgroundTap))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            sv.addGestureRecognizer(gesture)
        }
    }
    
    @objc private func backgroundTap() {
        endEditing()
    }
    
    public func setup(_ inputViews: [UIView]) {
        inputFields = []
        for field in inputViews {
            _ =  QDKbAccessory.init(field, delegate: self)
            if let view = field as? UITextField {
                inputFields.append(view)
            } else {
                if let view = field as? UITextView {
                    inputFields.append(view)
                } else {
                    print("Wrong input \(field)")
                }
            }
        }
        updateReturnKey()
    }
    
}

extension QDFormViewController: QDKbAccessoryProtocol {
    
    private func updateReturnKey() {
        var index = 0
        let count = inputFields.count
        for field in inputFields {
            index += 1
            let accessoryView = field.inputAccessoryView as? QDKbAccessory
            accessoryView?.leftButton.isHidden = index == 1
            accessoryView?.rightButton.isHidden = index == count
        }
    }
    
    private func moveToNextField(_ currentField: UIView) -> Bool {
        if let index = inputFields.firstIndex(of: currentField), index + 1 < inputFields.count {
            currentField.resignFirstResponder()
            inputFields[index + 1].becomeFirstResponder()
            return true
        }
        return false
    }
    
    private func moveToPrevField(_ currentField: UIView) -> Bool {
        if let index = inputFields.firstIndex(of: currentField), index > 0 {
            currentField.resignFirstResponder()
            inputFields[index - 1].becomeFirstResponder()
            return true
        }
        return false
    }
    
    public func accessoryRightTap(_ accessory: QDKbAccessory) {
        _ = moveToNextField(accessory.field!)
    }
    
    public func accessoryLeftTap(_ accessory: QDKbAccessory) {
        _ = moveToPrevField(accessory.field!)
    }
    
    public func accessoryHideTap(_ accessory: QDKbAccessory) {
        accessory.field!.resignFirstResponder()
    }
    
}

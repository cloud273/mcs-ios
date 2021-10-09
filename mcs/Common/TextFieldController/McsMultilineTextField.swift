/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*/

import UIKit
import MaterialComponents
import QDCore

class McsMultilineTextField: MDCMultilineTextField {
    
    class func create(_ view: UIView, pastable: Bool = true) -> McsMultilineTextField {
        return {
            var tf: McsMultilineTextField
            if pastable {
                tf = McsMultilineTextField.init()
            } else {
                tf = QDUnPastableMultilineTextField.init()
            }
            tf.backgroundColor = .clear
            view.addFixView(tf)
            return tf
            }()
    }
    
}

class QDUnPastableMultilineTextField: McsMultilineTextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        } else if action == #selector(cut(_:)) {
            return false
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
}

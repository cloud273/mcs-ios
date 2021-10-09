/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*/

import UIKit
import MaterialComponents
import QDCore

class McsTextField: MDCTextField {
    
    fileprivate init(_ delegate: UITextFieldDelegate) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func create(_ view: UIView, lPlaceHolder: String?, pastable: Bool = true, delegate: UITextFieldDelegate) -> McsTextField {
        return {
            var tf: McsTextField
            if pastable {
                tf = McsTextField.init(delegate)
            } else {
                tf = QDUnPastableTextField.init(delegate)
            }
            tf.backgroundColor = .clear
            view.addFixView(tf)
            tf.lPlaceHolder = lPlaceHolder
            return tf
            }()
    }
    
}

class QDUnPastableTextField: McsTextField {
    
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

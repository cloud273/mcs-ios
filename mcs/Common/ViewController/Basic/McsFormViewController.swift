/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import CLLocalization
import QDWhiteLabel

class McsFormViewController: QDFormViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default;
    }
    
    func setup(_ inputControllers: [McsTextInputControllerDefault]) {
        var list = [UIView]()
        for inputController in inputControllers {
            list.append(inputController.textField)
        }
        setup(list)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wBgColor = "background"
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: CLLocalization.languageChangedNotification, object: nil)
    }
    
    @objc
    func languageChanged() {
        
    }
    
}


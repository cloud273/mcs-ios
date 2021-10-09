/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/20.
 */

import UIKit
import QDCore
import CLLocalization

class MPActivateViewController: McsFormViewController {

    private var username: String!
    private var type: McsNotifyType!
    @IBOutlet private weak var codeView: UIView!
    @IBOutlet private weak var label: UILabel!
    
    private var codeController: McsTextInputControllerCode!
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.init(title: "Login".localized, style: .plain, target: nil, action: nil)
        navigationController?.viewControllers = [navigationController!.viewControllers.first!, self]
        codeController = McsTextInputControllerCode.init(codeView, lPlaceHolder: "Activation_code", pastable: true, require: true, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([codeController])
        label.text = "Input_activation_code_message".localized.replacingOccurrences(of: "__notify_type__", with: type!.getText())
    }
    
    func setup(_ username: String, type: McsNotifyType) {
        self.username = username
        self.type = type
    }
    
    @IBAction private func sendTap(_ sender: Any) {
        endEditing()
        codeController.showErrorIfNeed()
        if codeController.isValid {
            let code = codeController.value as! String
            McsProgressHUD.show(self)
            McsPatientActivateApi.init(username, code: code).run() { (success, message, code) in
                McsProgressHUD.hide(self)
                if success {
                    UIAlertController.show(self, title: "Successful".localized, message: "Activated_success_message".localized, close: "Close".localized) {
                        self.hide()
                    }
                } else {
                    // Error description
                    // 403 Invalid code
                    // 404 Not found => should not happen
                    // 406 Expired code
                    if code == 403 {
                        UIAlertController.show(self, title: "Error".localized, message: "Invalid_activation_code_message".localized, close: "Close".localized) {
                            self.hide()
                        }
                    } else if code == 404 {
                        UIAlertController.show(self, title: "Error".localized, message: "Not_found_account_message".localized, close: "Close".localized) {
                            self.hide()
                        }
                    } else if code == 406 {
                        UIAlertController.show(self, title: "Error".localized, message: "Expired_activation_code_message".localized, close: "Close".localized) {
                            self.hide()
                        }
                    } else {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
    private func hide() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func backButtonPressed(_ sender: Any?) {
        self.hide()
    }
    
}

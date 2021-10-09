/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/28.
 */

import UIKit
import QDCore

class MDResetPasswordViewController: McsFormViewController {
    
    private var username: String!
    private var type: McsNotifyType!
    
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var codeView: UIView!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var rePasswordView: UIView!
    
    private var codeController: McsTextInputControllerCode!
    private var passwordController: McsTextInputControllerPassword!
    private var rePasswordController: McsTextInputControllerRePassword!
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.init(title: "Login".localized, style: .plain, target: nil, action: nil)
        navigationController?.viewControllers = [navigationController!.viewControllers.first!, self]
        codeController = McsTextInputControllerCode.init(codeView, lPlaceHolder: "Code", pastable: true, require: true, delegate: nil)
        passwordController = McsTextInputControllerPassword.init(passwordView, lPlaceHolder: "New_password", pastable: false, require: true, delegate: nil)
        rePasswordController = McsTextInputControllerRePassword.init(rePasswordView, lPlaceHolder: "Retype_password", pastable: false, require: true, passwordController: passwordController, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([codeController, passwordController, rePasswordController])
        codeLabel.text = "Input_reset_password_code_message".localized.replacingOccurrences(of: "__notify_type__", with: type!.getText())
    }
    
    func setup(_ username: String, type: McsNotifyType) {
        self.username = username
        self.type = type
    }
    
    @IBAction private func sendTap(_ sender: Any) {
        endEditing()
        codeController.showErrorIfNeed()
        passwordController.showErrorIfNeed()
        rePasswordController.showErrorIfNeed()
        if codeController.isValid && passwordController.isValid && rePasswordController.isValid {
            let code = codeController.value as! String
            let password = passwordController.value as! String
            McsProgressHUD.show(self)
            McsAccountResetPasswordApi.init(.doctor, username: username, password: password, code: code).run() { (success, message, code) in
                McsProgressHUD.hide(self)
                if success {
                    UIAlertController.show(self, title: "Successful".localized, message: "Password_change_success_message".localized, close: "Close".localized) {
                        self.hide()
                    }
                } else {
                    // Error description
                    // 403 Invalid code
                    // 404 Not found => should not happen
                    // 406 Expired code
                    if code == 403 {
                        UIAlertController.show(self, title: "Error".localized, message: "Invalid_reset_password_code_message".localized, close: "Close".localized) {
                            self.hide()
                        }
                    } else if code == 406 {
                        UIAlertController.show(self, title: "Error".localized, message: "Expired_reset_password_code_message".localized, close: "Close".localized) {
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
    
}

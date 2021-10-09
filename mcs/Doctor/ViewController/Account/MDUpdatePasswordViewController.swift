/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/28.
 */

import UIKit
import QDCore
import CLLocalization

class MDUpdatePasswordViewController: McsFormViewController {
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var reNewPasswordView: UIView!
    private var passwordController: McsTextInputControllerPassword!
    private var newPasswordController: McsTextInputControllerPassword!
    private var reNewPasswordController: McsTextInputControllerRePassword!
    
    override func loadView() {
        super.loadView()
        passwordController = McsTextInputControllerPassword.init(passwordView, lPlaceHolder: "Password", pastable: false, require: true, delegate: nil)
        newPasswordController = McsTextInputControllerPassword.init(newPasswordView, lPlaceHolder: "New_password", pastable: false, require: true, delegate: nil)
        reNewPasswordController = McsTextInputControllerRePassword.init(reNewPasswordView, lPlaceHolder: "Retype_new_password", pastable: false, require: true, passwordController: newPasswordController, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([passwordController, newPasswordController, reNewPasswordController])
    }
    
    @IBAction private func sendTap(_ sender: Any) {
        endEditing()
        passwordController.showErrorIfNeed()
        newPasswordController.showErrorIfNeed()
        reNewPasswordController.showErrorIfNeed()
        if passwordController.isValid && newPasswordController.isValid && reNewPasswordController.isValid {
            let password = passwordController.value as! String
            let newPassword = newPasswordController.value as! String
            if let token = McsDatabase.instance.token {
                McsProgressHUD.show(self)
                McsAccountUpdatePasswordApi.init(.doctor, token: token, password: password, newPassword: newPassword).run { (success, token, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        McsDatabase.instance.updateAccount(token!)
                        UIAlertController.show(self, title: "Successful".localized, message: nil, close: "Close".localized) {
                            self.navigationController!.popViewController(animated: true)
                        }
                    } else {
                        // Error description
                        // 403 Invalid/Expired token
                        // 404 Invalid password
                        if code == 404 {
                            UIAlertController.show(self, title: "Error".localized, message: "Wrong_password_message".localized, close: "Close".localized)
                        } else if (code != 403) {
                            UIAlertController.generalErrorAlert(self)
                        }
                    }
                }
            }
        }
    }
    
    class func create() -> MDUpdatePasswordViewController {
        return UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "updatePasswordVc") as! MDUpdatePasswordViewController
    }
        
}

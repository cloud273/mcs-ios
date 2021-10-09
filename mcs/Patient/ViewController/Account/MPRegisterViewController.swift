/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPRegisterViewController: McsFormViewController {
    
    @IBOutlet private weak var usernameView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var rePasswordView: UIView!
    private var usernameController: McsTextInputControllerEmail!
    private var passwordController: McsTextInputControllerPassword!
    private var rePasswordController: McsTextInputControllerRePassword!
    
    override func loadView() {
        super.loadView()
        usernameController = McsTextInputControllerEmail.init(usernameView, lPlaceHolder: "Email", pastable: true, require: true, delegate: nil)
        passwordController = McsTextInputControllerPassword.init(passwordView, lPlaceHolder: "Password", pastable: false, require: true, delegate: nil)
        rePasswordController = McsTextInputControllerRePassword.init(rePasswordView, lPlaceHolder: "Retype_password", pastable: false, require: true, passwordController: passwordController, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([usernameController, passwordController, rePasswordController])
    }
    
    @IBAction func sendTap(_ sender: Any) {
        endEditing()
        usernameController.showErrorIfNeed()
        passwordController.showErrorIfNeed()
        rePasswordController.showErrorIfNeed()
        if usernameController.isValid && passwordController.isValid && rePasswordController.isValid {
            let username = usernameController.value as! String
            let password = passwordController.value as! String
            McsProgressHUD.show(self)
            McsPatientRegisterApi.init(username, password: password, language: McsDatabase.instance.language).run() { (success, type, code) in
                McsProgressHUD.hide(self)
                if success {
                    self.performSegue(withIdentifier: "activateSegue", sender: type)
                } else {
                    // Error description
                    // 409 Existed account
                    if code == 409 {
                        UIAlertController.show(self, title: "Error".localized, message: "Existed_username".localized, close: "Close".localized)
                    } else {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activateSegue" {
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Login".localized, style: .plain, target: nil, action: nil)
            let vc = segue.destination as! MPActivateViewController
            vc.setup((usernameController.value as! String), type: (sender as! McsNotifyType))
        }
    }
    
}

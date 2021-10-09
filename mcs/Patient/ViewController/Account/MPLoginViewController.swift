/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

protocol MPLoginProtocol: AnyObject {
    func didSuccess()
}

class MPLoginViewController: McsFormViewController {
    
    @IBOutlet private weak var usernameView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    private var usernameController: McsTextInputControllerEmail!
    private var passwordController: McsTextInputControllerPassword!
    private var delegate: MPLoginProtocol?
    
    override func loadView() {
        super.loadView()
        usernameController = McsTextInputControllerEmail.init(usernameView, lPlaceHolder: "Email", pastable: true, require: true, delegate: nil)
        passwordController = McsTextInputControllerPassword.init(passwordView, lPlaceHolder: "Password", pastable: false, require: true, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([usernameController, passwordController])
    }
    
    @IBAction private func loginTap(_ sender: Any) {
        endEditing()
        usernameController.showErrorIfNeed()
        passwordController.showErrorIfNeed()
        if usernameController.isValid && passwordController.isValid {
            let username = usernameController.value as! String
            let password = passwordController.value as! String
            McsProgressHUD.show(self)
            McsAccountLoginApi.init(.patient, username: username, password: password, deviceToken: McsDatabase.instance.deviceToken).run() { (success, token, code) in
                if success {
                    if code == 202 {
                        McsProgressHUD.hide(self)
                        self.performSegue(withIdentifier: "createSegue", sender: token)
                    } else {
                        McsPatientDetailApi.init(token!).run { (success, account, code) in
                            McsProgressHUD.hide(self)
                            if success {
                                McsDatabase.instance.setAccount(account!, token: token!)
                                self.dismiss(animated: true, completion: {
                                    self.delegate?.didSuccess()
                                })
                            } else {
                                UIAlertController.generalErrorAlert(self)
                            }
                        }
                    }
                } else {
                    McsProgressHUD.hide(self)
                    // Error description
                    // 401 Invalid password
                    // 403 Inactivated account
                    // 404 Not found
                    // 423 Account is locked
                    if code == 401 {
                        UIAlertController.show(self, title: "Error".localized, message: "Wrong_login_info".localized, close: "Close".localized)
                    } else if code == 403 {
                        UIAlertController.show(self, title: "Error".localized, message: "Inactive_account_message".localized, close: "Close".localized)
                    } else if code == 404 {
                        UIAlertController.show(self, title: "Error".localized, message: "Wrong_login_info".localized, close: "Close".localized)
                    } else if code == 423 {
                        UIAlertController.show(self, title: "Error".localized, message: "Locked_account_message".localized, close: "Close".localized)
                    } else {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createSegue" {
            let vc = segue.destination as! MPCreateAccountViewController
            vc.setup((sender as! String), username: (usernameController.value as! String), delegate: delegate)
        }
    }
    
    class func show(_ controller: UIViewController, delegate: MPLoginProtocol?) {
        let nvc = UIStoryboard(name: "Account", bundle: nil).instantiateInitialViewController() as! UINavigationController
        nvc.modalPresentationStyle = .fullScreen
        let vc = nvc.viewControllers[0] as! MPLoginViewController
        vc.delegate = delegate
        controller.present(nvc, animated: true, completion: nil)
    }
    
}

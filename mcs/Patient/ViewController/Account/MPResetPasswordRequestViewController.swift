/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPResetPasswordRequestViewController: McsFormViewController {
    
    @IBOutlet private weak var usernameView: UIView!
    private var usernameController: McsTextInputControllerEmail!
    
    override func loadView() {
        super.loadView()
        usernameController = McsTextInputControllerEmail.init(usernameView, lPlaceHolder: "Email", pastable: true, require: true, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([usernameController])
    }
    
    @IBAction private func sendTap(_ sender: Any) {
        endEditing()
        endEditing()
        usernameController.showErrorIfNeed()
        if usernameController.isValid {
            let username = usernameController.value as! String
            McsProgressHUD.show(self)
            McsAccountResetPasswordRequestApi.init(.patient, username: username, language: McsDatabase.instance.language).run() { (success, type, code) in
                McsProgressHUD.hide(self)
                if success {
                    self.performSegue(withIdentifier: "resetSegue", sender: type)
                } else {
                    // Error description
                    // 404 Not found
                    if code == 404 {
                        UIAlertController.show(self, title: "Error".localized, message: "Not_found_account_message".localized, close: "Close".localized)
                    } else {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resetSegue" {
            let vc = segue.destination as! MPResetPasswordViewController
            vc.setup((usernameController.value as! String), type: (sender as! McsNotifyType))
        }
    }
    
}

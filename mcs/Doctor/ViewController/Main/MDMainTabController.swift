/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/27.
 */

import UIKit
import QDWhiteLabel

class MDMainTabController: UITabBarController {
    
    private var appeared : Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default;
    }
    
    private var isShowingLogin = false
    
    override func loadView() {
        super.loadView()
        self.tabBar.barTintColor = "footer-background".whiteLabelColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.registerDeviceToken), name: accountDidSetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearDeviceToken), name: accountWillLogoutNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLogin), name: accountDidClearNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !appeared {
            appeared = true
            verifyAccount()
        }
    }
    
    private func verifyAccount() {
        if let token = McsDatabase.instance.existedToken {
            McsProgressHUD.show(self.view, text: "Getting_account".localized)
            McsDoctorClinicInfoApi.init(token).run { (success, doctor, clinic, code) in
                McsProgressHUD.hide(self)
                if success {
                    McsDatabase.instance.setAccount(doctor!, clinic: clinic!)
                } else {
                    if code != 403 {
                        UIAlertController.show(self, title: "Error".localized, message: "Backend_connect_fail_message".localized, close: "Retry", action: {
                            self.verifyAccount()
                        })
                    }
                }
            }
        } else {
            showLogin()
        }
    }
    
    @objc func showLogin() {
        if !isShowingLogin {
            isShowingLogin = true
            if presentedViewController != nil {
                self.dismiss(animated: false) {
                    MDLoginViewController.show(self, delegate: self)
                }
            } else {
                MDLoginViewController.show(self, delegate: self)
            }
            if let vcs = viewControllers {
                for vc in vcs {
                    if let nvc = vc as? UINavigationController {
                        nvc.popToRootViewController(animated: false)
                    }
                }
                selectedIndex = 0
            }
        }
    }
    
    @objc private func registerDeviceToken() {
        McsApnsService.instance.registerDeviceTokenIfNeed()
    }
    
    @objc private func clearDeviceToken() {
        McsApnsService.instance.clearDeviceTokenIfNeed()
    }
    
}

extension MDMainTabController: MDLoginProtocol {
    
    func didSuccess() {
        isShowingLogin = false
    }
}

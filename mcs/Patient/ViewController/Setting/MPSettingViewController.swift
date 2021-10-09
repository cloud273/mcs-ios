/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPSettingViewController: McsTableViewController {
    
    private let textCellId = "textCell"
    private let accCellId = "accCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.tableView.register(UINib(nibName: "McsTextCell", bundle: nil), forCellReuseIdentifier: textCellId)
        self.tableView.register(UINib(nibName: "MPPatientCell", bundle: nil), forCellReuseIdentifier: accCellId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: accountInfoDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: accountDidSetNotification, object: nil)
        self.reloadView()
    }
    
    @objc override func refresh() {
        if let token = McsDatabase.instance.token {
            McsPatientDetailApi.init(token).run { (success, patient, code) in
                if success {
                    McsDatabase.instance.updateAccount(patient!)
                }
                self.endRefresh()
            }
        } else {
            self.endRefresh()
        }
    }
    
    @objc private func reloadView() {
        var sessions = [QDSectionData]()
        if let account = McsDatabase.instance.account {
            sessions.append(QDSectionData(
                [
                    QDCellData.init("account", cell: accCellId, data: account),
                    QDCellData.init("changePassword", cell: textCellId, data: "Change_password".localized),
                    QDCellData.init("signOut", cell: textCellId, data: "Logout".localized)
                ], header: QDCellData.init(data: "Account".localized)
            ))
        }
        sessions.append(QDSectionData(
            [
                QDCellData.init("aboutUs", cell: textCellId, data: "About_us".localized),
                QDCellData.init("freqQuestion", cell: textCellId, data: "FAQ".localized),
                QDCellData.init("termCondition", cell: textCellId, data: "Term_condition".localized),
                QDCellData.init("contact", cell: textCellId, data: "Contact".localized)
            ], header: QDCellData.init(data: "Support".localized)
        ))
        list = sessions
    }
    
    override func userDidTapCell(_ id: Any?, data: Any?) {
        if let id = id as? String {
            if id == "account" {
                McsProgressHUD.show(self)
                McsPatientDetailApi.init(McsDatabase.instance.token!).run { (success, patient, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        McsDatabase.instance.updateAccount(patient!)
                        let vc = MPUpdateAccountViewController.create()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            } else if id == "changePassword" {
                let vc = MPUpdatePasswordViewController.create()
                self.navigationController?.pushViewController(vc, animated: true)
            } else if id == "signOut" {
                UIAlertController.show(self, title: nil, message: "Logout_message".localized, no: "Cancel".localized, yes: "Ok".localized) {
                    McsDatabase.instance.clear()
                }
            } else {
                var url: URL!
                if id == "aboutUs" {
                    url = URL.init(string: AboutUsUrl)
                } else if id == "freqQuestion" {
                    url = URL.init(string: FaqUrl)
                } else if id == "termCondition" {
                    url = URL.init(string: TermUrl)
                } else if id == "contact" {
                    url = URL.init(string: ContactUrl)
                }
                let vc = McsWebViewController.init(nibName: nil, bundle: nil)
                vc.title = data as? String
                vc.content = WebUrlContent.init(url)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}


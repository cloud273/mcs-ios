/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/28.
 */

import UIKit
import QDCore

class MDSettingViewController: McsTableViewController {
    
    private let textCellId = "textCell"
    private let accCellId = "accCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.tableView.register(UINib(nibName: "McsTextCell", bundle: nil), forCellReuseIdentifier: textCellId)
        self.tableView.register(UINib(nibName: "MDDoctorCell", bundle: nil), forCellReuseIdentifier: accCellId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: accountInfoDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: accountDidSetNotification, object: nil)
        self.reloadView()
    }
    
    @objc override func refresh() {
        if let token = McsDatabase.instance.token {
            McsDoctorClinicInfoApi.init(token).run { (success, doctor, clinic, code) in
                if success {
                    McsDatabase.instance.updateAccount(doctor!, clinic: clinic!)
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
                    QDCellData.init("doctor", cell: accCellId, data: account),
                    QDCellData.init("changePassword", cell: textCellId, data: "Change_password".localized),
                    QDCellData.init("signOut", cell: textCellId, data: "Logout".localized)
                ], header: QDCellData.init(data: "Account".localized)
            ))
        }
        sessions.append(QDSectionData(
            [
                QDCellData.init("clinic", cell: textCellId, data: "Clinic".localized),
                QDCellData.init("package", cell: textCellId, data: "Package".localized),
                QDCellData.init("schedule", cell: textCellId, data: "Schedule".localized),
            ], header: QDCellData.init(data: "Other_information".localized)
        ))
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
            if id == "doctor" {
                McsProgressHUD.show(self)
                McsDoctorDetailApi.init(McsDatabase.instance.token!).run() { (success, doctor, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        McsDatabase.instance.updateAccount(doctor!)
                        self.performSegue(withIdentifier: "doctorSegue", sender: nil)
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            } else if id == "changePassword" {
                let vc = MDUpdatePasswordViewController.create()
                self.navigationController?.pushViewController(vc, animated: true)
            } else if id == "signOut" {
                UIAlertController.show(self, title: nil, message: "Logout_message".localized, no: "Cancel".localized, yes: "Ok".localized) {
                    McsDatabase.instance.clear()
                }
            } else if id == "clinic" {
                McsProgressHUD.show(self)
                McsDoctorClinicDetailApi.init(McsDatabase.instance.token!).run() { (success, clinic, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        McsDatabase.instance.clinic = clinic
                        self.performSegue(withIdentifier: "clinicSegue", sender: nil)
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            } else if id == "package" {
                McsProgressHUD.show(self)
                McsDoctorListPackageApi.init(McsDatabase.instance.token!).run() { (success, packages, code) in
                    if success {
                        McsProgressHUD.hide(self)
                        self.performSegue(withIdentifier: "packageSegue", sender: packages)
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
                
            } else if id == "schedule" {
                McsProgressHUD.show(self)
                MDWorkingTimeHelper.reload { (success, from, to, workingTimes, packages, expired) in
                    McsProgressHUD.hide(self)
                    if success {
                        if packages!.count > 0 {
                            self.performSegue(withIdentifier: "scheduleSegue", sender: [workingTimes!, packages!, from, to])
                        } else {
                            UIAlertController.show(self, title: "Error".localized, message: "No_package_contact_clinic_admin_message".localized)
                        }
                    } else if !expired {
                        UIAlertController.generalErrorAlert(self)
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "packageSegue" {
            let vc = segue.destination as! MDListPackageViewController
            vc.setup(sender as! [McsPackage])
        } else if segue.identifier == "scheduleSegue" {
            let array = sender as! [Any]
            let vc = segue.destination as! MDScheduleViewController
            vc.setup(array[0] as! [MDWorkingTime], packages: array[1] as! [McsPackage], from: array[2] as! Date, to: array[3] as! Date)
        }
    }
    
}


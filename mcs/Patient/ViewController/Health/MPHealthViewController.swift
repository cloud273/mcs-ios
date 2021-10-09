/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/05/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPHealthViewController: McsTableViewController, McsCheckCellProtocol {
    
    private let textCellId = "textCell"
    private let textDetailCellId = "textDetailCell"
    let checkCellId = "checkCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: accountDidSetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: accountGenderDidUpdatedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: accountHealthInfoDidChangeNotification, object: nil)
        self.tableView.register(UINib(nibName: "McsTextDetailCell", bundle: nil), forCellReuseIdentifier: textDetailCellId)
        self.tableView.register(UINib(nibName: "McsTextAddCell", bundle: nil), forCellReuseIdentifier: textCellId)
        self.tableView.register(UINib(nibName: "McsCheckCell", bundle: nil), forCellReuseIdentifier: checkCellId)
        reloadView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func refresh() {
        if let token = McsDatabase.instance.token {
            McsPatientHealthDetailApi.init(token).run() { (success, alleries, surgeries, medications, code) in
                if success {
                    McsDatabase.instance.updateAccount(allergies: alleries, surgeries: surgeries, medications: medications)
                }
                self.endRefresh()
            }
        } else {
            self.endRefresh()
        }
    }
    
    func getTableData() -> [QDSectionData] {
        var allergies = [QDCellData]()
        var surgeries = [QDCellData]()
        var medications = [QDCellData]()
        if let patient = McsDatabase.instance.account as? McsPatient {
            if let objs = patient.allergies {
                for obj in objs {
                    allergies.append(QDCellData.init(cell: textDetailCellId, data: obj, editable: true, accessory: .disclosureIndicator))
                }
            }
            allergies.append(QDCellData.init("allergy", cell: textCellId, data: "Add_allergy".localized, editable: false))
            if let objs = patient.surgeries {
                for obj in objs {
                    surgeries.append(QDCellData.init(cell: textDetailCellId, data: obj, editable: true, accessory: .disclosureIndicator))
                }
            }
            surgeries.append(QDCellData.init("surgery", cell: textCellId, data: "Add_surgery".localized, editable: false))
            
            if let objs = patient.medications {
                for obj in objs {
                    medications.append(QDCellData.init(cell: checkCellId, data: obj, editable: false))
                }
            }
        }
        return [
            QDSectionData(allergies, header: QDCellData.init(data: "Allergy".localized)),
            QDSectionData(surgeries, header: QDCellData.init(data: "Surgery".localized)),
            QDSectionData(medications, header: QDCellData.init(data: "Medication".localized))
        ]
    }
    
    @objc
    func reloadView() {
        list = getTableData()
    }
    
    override func render(_ cell: UITableViewCell!, id: Any?, data: Any?) {
        super.render(cell, id: id, data: data)
        if let cell = cell as? McsCheckCell {
            cell.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allergySegue" {
            if let allergy = sender as? McsAllergy {
                let vc = segue.destination as! MPAllergyViewController
                vc.setup(allergy)
            }
        } else if segue.identifier == "surgerySegue" {
            if let surgery = sender as? McsSurgery {
                let vc = segue.destination as! MPSurgeryViewController
                vc.setup(surgery)
            }
        }
    }
    
    override func userDidTapCell(_ id: Any?, data: Any?) {
        if let id = id as? String {
            switch id {
            case "allergy":
                performSegue(withIdentifier: "allergySegue", sender: nil)
                break
            case "surgery":
                performSegue(withIdentifier: "surgerySegue", sender: nil)
                break
            default:
                return
            }
        } else {
            if let allery = data as? McsAllergy {
                performSegue(withIdentifier: "allergySegue", sender: allery)
            }
            if let surgery = data as? McsSurgery {
                performSegue(withIdentifier: "surgerySegue", sender: surgery)
            }
        }
    }
    
    override func userDidTapDeleteCell(_ id: Any?, data: Any?) {
        if let allery = data as? McsAllergy {
            // Error description
            // 403 Invalid/Expired token
            // 404 Not found
            McsProgressHUD.show(self)
            McsPatientAllergyDeleteApi.init(McsDatabase.instance.token!, id: allery.id!).run { (success, message, code) in
                McsProgressHUD.hide(self)
                if success  {
                    McsDatabase.instance.delete(allergy: allery.id!)
                } else {
                    if code == 404 {
                        McsDatabase.instance.delete(allergy: allery.id!)
                        self.refresh()
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
        if let surgery = data as? McsSurgery {
            // Error description
            // 403 Invalid/Expired token
            // 404 Not found
            McsProgressHUD.show(self)
            McsPatientSurgeryDeleteApi.init(McsDatabase.instance.token!, id: surgery.id!).run { (success, message, code) in
                McsProgressHUD.hide(self)
                if success  {
                    McsDatabase.instance.delete(surgery: surgery.id!)
                } else {
                    if code == 404 {
                        McsDatabase.instance.delete(surgery: surgery.id!)
                        self.refresh()
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
    func userDidChangeSwitch(_ id: Any?, data: Any?, value: Bool) {
        if let cMedication = data as? McsMedication {
            // Error description
            // 403 Invalid/Expired token
            // 404 Not found => should not happen
            McsProgressHUD.show(self)
            let medication = McsMedication.update(id: cMedication.id!, value: value ? .yes : .no, note: cMedication.note)
            McsPatientMedicationUpdateApi.init(McsDatabase.instance.token!, medication: medication).run { (sucess, message, code) in
                McsProgressHUD.hide(self)
                if sucess {
                    medication.name = cMedication.name
                    McsDatabase.instance.update(medication)
                } else {
                    if code != 403 {
                        self.reloadView()
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
}


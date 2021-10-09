/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/09.
 */

import UIKit
import QDCore
import CLLocalization

class MPBookingHealthViewController: MPHealthViewController {

    private var appointment: McsAppointment!
    
    private var share: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setup(_ appointment: McsAppointment) {
        self.appointment = appointment
    }
    
    override func getTableData() -> [QDSectionData] {
        var list: [QDSectionData]!
        let section = QDSectionData.init([QDCellData.init("share", cell: checkCellId, data: McsCheckCell.Input.init("Booking_health_message".localized, on: share))], header: QDCellData.init(data: "Share".localized))
        
        if share {
            list = super.getTableData()
            list.insert(section, at: 0)
        } else {
            list = [section]
        }
        return list
    }
    
    override func userDidChangeSwitch(_ id: Any?, data: Any?, value: Bool) {
        if let id = id as? String, id == "share" {
            share = value
            self.reloadView()
        } else {
            super.userDidChangeSwitch(id, data: data, value: value)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        McsProgressHUD.show(self)
        McsPatientListSpecialtyApi.init(McsDatabase.instance.token!, symptoms: appointment.symptoms).run { (success, specialties, code) in
            McsProgressHUD.hide(self)
            if success {
                self.performSegue(withIdentifier: "specialtySegue", sender: specialties!)
            } else {
                if code != 403 {
                    UIAlertController.generalErrorAlert(self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "specialtySegue" {
            let vc = segue.destination as! MPBookingSpecialtyViewController
            let patient = McsDatabase.instance.account as! McsPatient
            let allergies = McsUtility.clone(share ? patient.allergies : nil , withoutID: true)
            let surgeries = McsUtility.clone(share ? patient.surgeries : nil , withoutID: true)
            let medications = McsUtility.clone(share ? patient.medications : nil , withoutID: true)
            appointment.set(allergies, surgeries: surgeries, medications: medications)
            vc.setup(sender as! [McsSpecialty], appointment: appointment)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

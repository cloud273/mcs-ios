/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore

class MDAppointmentButtonCell: McsCell {
    
    
    @IBOutlet weak var beginButton: UIButton!
    
    override func setData(_ data: Any?) {
        let enable = data as! Bool
        if enable {
            beginButton.wBgColor = "green-color"
        } else {
            beginButton.wBgColor = "lightgray-color"
        }
    }
}

class MDAppointmentViewController: McsTableViewController {
    
    private var appointment: McsAppointment!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        reloadView()
    }
    
    func setup(_ appointment: McsAppointment) {
        self.appointment = appointment
    }
    
    func isShowButton() -> Bool {
        return true
    }
    
    override func refresh() {
        if let token = McsDatabase.instance.token {
            McsDoctorAppointmentDetailApi.init(token, id: appointment.id!).run() { (success, appointment, code) in
                if (success) {
                    self.appointment = appointment!
                }
                self.endRefresh()
            }
        } else {
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        imageView.setImageUrl(appointment.patientInfo!.image, placeholder: patientIcon)
        var statusAccessory: UITableViewCell.AccessoryType = .none
        if let status = appointment.status {
            if status.by != .doctor && status.note != nil {
                statusAccessory = .detailButton
            }
        }
        let bookingCells = [
            QDCellData.init("status", cell: "status", data: appointment.status!.value!.toString(), accessory: statusAccessory),
            QDCellData.init("order", cell: "order", data: appointment.order!.toString()),
            QDCellData.init(cell: "patient", data: appointment.patientInfo!.profile!.fullname),
            QDCellData.init(cell: "specialty", data: appointment.specialty),
            QDCellData.init(cell: "time", data: appointment.begin!.toAppDateTimeString()),
            QDCellData.init(cell: "price", data: appointment.price!.toString())
        ]
        var healthCells = [
            QDCellData.init(cell: "symptom", data: appointment.symptoms)
        ]
        if let allergies = appointment.allergies, allergies.count > 0 {
            healthCells.append(QDCellData.init(cell: "allergy", data: allergies))
        }
        if let surgeries = appointment.surgeries, surgeries.count > 0 {
            healthCells.append(QDCellData.init(cell: "surgery", data: surgeries))
        }
        if let medications = appointment.medications, medications.count > 0 {
            healthCells.append(QDCellData.init(cell: "medication", data: medications))
        }
        if isShowButton() {
            healthCells.append(QDCellData.init(cell: "button", data: appointment.beginable!))
        }
        list = [
            QDSectionData.init(bookingCells, header: QDCellData.init(data: "Booking_information".localized)),
            QDSectionData.init(healthCells, header: QDCellData.init(data: "Health_information".localized))
        ]
    }
    
    // protected
    override func userDidTapAccessoryButton(_ id: Any?, data: Any?) {
        if let id = id as? String, id == "status" {
            let status = appointment.status!
            let message = status.note
            UIAlertController.show(self, title: "Message_from".localized + " " + status.by.toString(), message: message!, close: "Close".localized)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "prescriptionSegue" {
            let vc = segue.destination as! MDPrescriptionViewController
            vc.setup(appointment)
        }
    }
    
    @IBAction func beginButtonPressed(_ sender: Any) {
        if appointment.beginable! {
            UIAlertController.show(self, title: nil, message: "Begin_appointment_message".localized, no: "No".localized, yes: "Agree".localized) {
                // Error description
                // 403 Invalid/Expired token
                // 404 Not found
                // 406 Cannot be started
                McsProgressHUD.show(self)
                let note = "Started"
                McsDoctorBeginAppointmentApi.init(McsDatabase.instance.token!, id: self.appointment.id!, note: note).run() { (success, message, code) in
                    McsProgressHUD.hide(self)
                    if (success) {
                        self.appointment.status?.by = .doctor
                        self.appointment.status?.value = .started
                        self.appointment.status?.note = note
                        self.reloadView()
                        NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                        self.performSegue(withIdentifier: "prescriptionSegue", sender: nil)
                    } else {
                        if code == 404 {
                            NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                            UIAlertController.show(self, title: "Error".localized, message: "Not_found_appointment_message".localized, close: "Close".localized) {
                                self.navigationController!.popViewController(animated: true)
                            }
                        } else if code == 406 {
                            NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                            self.refresh()
                            UIAlertController.show(self, title: "Error".localized, message: "No_beginable_appointment_message".localized, close: "Close".localized)
                        } else if code != 403 {
                            UIAlertController.generalErrorAlert(self)
                        }
                    }
                }
            }
        } else {
            UIAlertController.show(self, title: nil, message: "Wait".localized, close: "Close".localized)
        }
        
    }
    
}


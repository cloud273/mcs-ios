/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPAppointmentViewController: McsTableViewController {
    
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
    
    override func refresh() {
        if let token = McsDatabase.instance.token {
            McsPatientAppointmentDetailApi.init(token, id: appointment.id!).run() { (success, appointment, code) in
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
        imageView.setImageUrl(appointment.doctorInfo!.image, placeholder: doctorIcon)
        var statusAccessory: UITableViewCell.AccessoryType = .none
        if let status = appointment.status {
            if status.by != .patient && status.note != nil {
                statusAccessory = .detailButton
            }
        }
        let bookingCells = [
            QDCellData.init(cell: "time", data: appointment.begin!.toAppDateTimeString()),
            QDCellData.init("status", cell: "status", data: appointment.status!.value!.toString(), accessory: statusAccessory),
            QDCellData.init("order", cell: "order", data: appointment.order!.toString()),
            QDCellData.init(cell: "doctor", data: appointment.doctorInfo!.profile!.fullname),
            QDCellData.init(cell: "specialty", data: appointment.specialty),
            QDCellData.init(cell: "clinic", data: appointment.clinicInfo),
            QDCellData.init(cell: "price", data: appointment.price!.toString()),
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
        if appointment.cancelable! {
              healthCells.append(QDCellData.init(cell: "button", data: nil))
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
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        McsConfigReasonApi.init().run { (success, patientCancels, clinicRejects, systemRejects) in
            if success {
                let sheet = UIAlertController.init(title: "Cancellation_reason_title".localized, message: nil, preferredStyle: .alert)
                let reasons = patientCancels!
                for reason in reasons {
                    let note = reason.getText()
                    sheet.addAction(UIAlertAction.init(title: note, style: .default, handler: { (_) in
                        UIAlertController.show(self, title: nil, message: "Cancel_appointment_message".localized, no: "No".localized, yes: "Agree".localized) {
                            // Error description
                            // 403 Invalid/Expired token
                            // 404 Not found
                            // 406 Cannot be cancelled
                            McsProgressHUD.show(self)
                            McsPatientCancelAppointmentApi.init(McsDatabase.instance.token!, id: self.appointment.id!, note: note).run() { (success, message, code) in
                                McsProgressHUD.hide(self)
                                if (success) {
                                    NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                                    UIAlertController.show(self, title: "Cancelled_successful".localized, message: nil, close: "Close".localized) {
                                        self.navigationController!.popViewController(animated: true)
                                    }
                                } else {
                                    if code == 404 {
                                        NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                                        UIAlertController.show(self, title: "Error".localized, message: "Not_found_appointment_message".localized, close: "Close".localized) {
                                            self.navigationController!.popViewController(animated: true)
                                        }
                                    } else if code == 406 {
                                        self.refresh()
                                        UIAlertController.show(self, title: "Error".localized, message: "No_cancelable_appointment_message".localized, close: "Close".localized)
                                    } else if code != 403 {
                                        UIAlertController.generalErrorAlert(self)
                                    }
                                }
                            }
                        }
                    }))
                }
                sheet.addAction(UIAlertAction.init(title: "No".localized, style: .cancel, handler: { (_) in
                    
                }))
                sheet.show(self, from: sender as? UIView)
            } else {
                UIAlertController.generalErrorAlert(self)
            }
        }
        
    }
    
}


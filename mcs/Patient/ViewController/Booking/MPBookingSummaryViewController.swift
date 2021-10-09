/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/09.
 */

import UIKit
import QDCore
import CLLocalization

class MPBookingSummaryViewController: McsTableViewController {

    private var doctor: McsDoctor!
    private var appointment: McsAppointment!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookButton: UIButton!
    private var bookBtnColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookBtnColor = bookButton.backgroundColor
        reloadBookButton(false)
        reloadView()
    }

    func setup(_ doctor: McsDoctor, appointment: McsAppointment) {
        self.doctor = doctor
        self.appointment = appointment
    }
    
    func reloadView() {
        imageView.setImageUrl(doctor!.image, placeholder: doctorIcon)
        let bookingCells = [
            QDCellData.init(cell: "doctor", data: doctor!.profile!.fullname),
            QDCellData.init(cell: "specialty", data: appointment.specialty),
            QDCellData.init(cell: "clinic", data: doctor!.clinic),
            QDCellData.init(cell: "time", data: appointment.begin.toAppDateTimeString()),
            QDCellData.init(cell: "price", data: appointment.price.toString())
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
        list = [
            QDSectionData.init(bookingCells, header: QDCellData.init(data: "Booking_information".localized)),
            QDSectionData.init(healthCells, header: QDCellData.init(data: "Health_information".localized))
        ]
    }
    
    func reloadBookButton(_ enable: Bool) {
        if enable {
            bookButton.isEnabled = true
            bookButton.wBgColor = "blue-color"
        } else {
            bookButton.isEnabled = false
            bookButton.wBgColor = "lightgray-color"
        }
    }

    @IBAction func agreeButtonPressed(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        reloadBookButton(btn.isSelected)
    }
    
    @IBAction func termButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        if let token = McsDatabase.instance.token {
            McsProgressHUD.show(self)
            McsPatientAppointmentCreateApi.init(token, appointment: appointment).run { (success, id, code) in
                McsProgressHUD.hide(self)
                if success {
                    NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                    UIAlertController.show(self, title: "Successful".localized, message: nil, close: "Close".localized) {
                        NotificationCenter.default.post(name: moveToAppointmentListNotification, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    if code == 406 {
                        UIAlertController.show(self, title: nil, message: "Unavailable_doctor_message".localized, close: "Close".localized) {
                            let vc = self.navigationController!.viewControllers[max(self.navigationController!.viewControllers.count - 4, 0)]
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
}

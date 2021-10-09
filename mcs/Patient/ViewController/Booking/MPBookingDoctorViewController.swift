/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization
import Cosmos

class MPBookingDoctorViewController: McsTableViewController {
    
    private var doctor: McsDoctor!
    private var appointment: McsAppointment!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noFbButton: UIButton!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var bookedLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    let ratingView = CosmosView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        ratingView.settings.starSize = 18
        ratingView.settings.starMargin = 0
        ratingView.settings.totalStars = 5
        ratingView.settings.fillMode = .precise
        ratingContainerView.addFixView(ratingView)
        reloadView()
    }
    
    func setup(_ doctor: McsDoctor, appointment: McsAppointment) {
        self.doctor = doctor
        self.appointment = appointment
    }
    
    override func refresh() {
        McsPatientDoctorDetailApi.init(McsDatabase.instance.token!, id: doctor.id!, type: appointment.type, specialtyCode: appointment.specialtyCode).run() { (success, doctor, code) in
            if success {
                self.doctor = doctor!
                self.reloadView()
            } else if code == 404 {
                UIAlertController.show(self, title: nil, message: "Unavailable_doctor_message".localized, close: "Close".localized) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else if code != 403 {
                UIAlertController.generalErrorAlert(self)
            }
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        if let package = doctor.packages?.first {
            continueButton.isEnabled = true
            continueButton.wBgColor = "blue-color"
            continueButton.setTitle("\("Choose".localized) (\("Price".localized) \(package.price!.toString()))", for: .normal)
        } else {
            continueButton.isEnabled = false
            continueButton.wBgColor = "lightgray-color"
            continueButton.setTitle("Choose".localized, for: .normal)
        }
        imageView.setImageUrl(doctor.image , placeholder: doctorIcon)
        noFbButton.setTitle("\("Feedback".localized) (\(doctor.noFb!.toString()))", for: .normal)
        ratingView.rating = doctor.rating!
        bookedLabel.text = "\("Booked".localized) (\(doctor.noApt!.toString()))"
        var cells = [QDCellData.init(cell: "info", data: doctor),
                     QDCellData.init(cell: "clinic", data: doctor.clinic)]
        if let position = doctor.office {
            cells.append(QDCellData.init(cell: "position", data: position))
        }
        cells.append(QDCellData.init(cell: "specialty", data: doctor.specialtiesString(nil)))
        if let startWork = doctor.startWork {
            let text = "\(startWork.yearOld().toString()) \("years".localized)"
            cells.append(QDCellData.init(cell: "experience", data: text))
        }
        if let biography = doctor.biography {
            cells.append(QDCellData.init(cell: "biography", data: biography))
        }
        if let certificates = doctor.clinic?.certificates {
            for certificate in certificates {
                cells.append(QDCellData.init(cell: "certificate", data: certificate, accessory: .detailButton))
            }
        }
        if let certificates = doctor.certificates {
            for certificate in certificates {
                cells.append(QDCellData.init(cell: "certificate", data: certificate, accessory: .detailButton))
            }
        }
        
        list = [
            QDSectionData.init(cells)
        ]
    }
    
    @IBAction func feedbackButtonPressed(_ sender: Any) {
        print("feedback")
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let helper = MPBookingTimeViewController.MPBookingTimeHelper.init(doctor.packages!.first!.id!)
        McsProgressHUD.show(self)
        helper.refresh { code in
            McsProgressHUD.hide(self)
            if code == 200 {
                if helper.isValid() {
                    self.performSegue(withIdentifier: "timeSegue", sender: helper)
                } else {
                    UIAlertController.show(self, title: nil, message: "Unavailable_doctor_message".localized, close: "Close".localized) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else if code == 404 {
                UIAlertController.show(self, title: nil, message: "Unavailable_doctor_message".localized, close: "Close".localized) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else if code != 403 {
                UIAlertController.generalErrorAlert(self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timeSegue" {
            let vc = segue.destination as! MPBookingTimeViewController
            appointment.set(doctor.packages!.first!)
            vc.setup((sender as! MPBookingTimeViewController.MPBookingTimeHelper), doctor: doctor, appointment: appointment)
        }
    }
    
    override func userDidTapAccessoryButton(_ id: Any?, data: Any?) {
        let vc = McsCertificateViewController.instance()
        vc.certificate = data as? McsCertificate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}


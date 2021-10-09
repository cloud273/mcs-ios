/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore

class MDPrescriptionViewController: McsViewController {
    
    private var appointment: McsAppointment!
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.init(title: "Appointment".localized, style: .plain, target: nil, action: nil)
        navigationController?.viewControllers = [navigationController!.viewControllers.first!, self]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(_ appointment: McsAppointment) {
        self.appointment = appointment
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        UIAlertController.show(self, title: nil, message: "Finish_appointment_message".localized, no: "No".localized, yes: "Agree".localized) {
            // Error description
            // 403 Invalid/Expired token
            // 404 Not found
            // 406 Cannot be started
            McsProgressHUD.show(self)
            McsDoctorFinishAppointmentApi.init(McsDatabase.instance.token!, id: self.appointment.id!, note: "Finished by doctor").run() { (success, message, code) in
                McsProgressHUD.hide(self)
                if (success) {
                    NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                    self.navigationController!.popToRootViewController(animated: true)
                } else {
                    if code == 404 {
                        NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                        UIAlertController.show(self, title: "Error".localized, message: "Not_found_appointment_message".localized, close: "Close".localized) {
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                    } else if code == 406 {
                        NotificationCenter.default.post(name: appointmentDidUpdatedNotification, object: nil)
                        self.refresh()
                        UIAlertController.show(self, title: "Error".localized, message: "No_finishable_appointment_message".localized, close: "Close".localized)
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
}


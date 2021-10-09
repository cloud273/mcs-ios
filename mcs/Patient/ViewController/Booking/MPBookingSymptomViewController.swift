/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/02.
 */

import UIKit
import QDCore
import CLLocalization

class MPBookingSymptomViewController: McsFormViewController {

    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var noteView: UIView!
    private var nameController: McsTextInputControllerSymptom!
    private var noteController: McsTextInputControllerSymptomWhen!
    
    private var appointment: McsAppointment!
    
    override func loadView() {
        super.loadView()
        nameController = McsTextInputControllerSymptom.init(nameView, lPlaceHolder: "Description_symptom", pastable: true, require: true, delegate: nil)
        noteController = McsTextInputControllerSymptomWhen.init(noteView, lPlaceHolder: "Symptom_when", pastable: true, require: true, delegate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup([nameController, noteController])
    }

    func setup(_ appointment: McsAppointment) {
        self.appointment = appointment
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        endEditing()
        nameController.showErrorIfNeed()
        noteController.showErrorIfNeed()
        if nameController.isValid && noteController.isValid {
            McsProgressHUD.show(self)
            McsPatientHealthDetailApi.init(McsDatabase.instance.token!).run() { (success, alleries, surgeries, medications, code) in
                McsProgressHUD.hide(self)
                if success {
                    McsDatabase.instance.updateAccount(allergies: alleries, surgeries: surgeries, medications: medications)
                    let symptom = McsSymptom.create(name: self.nameController.value as! String, note: self.noteController.value as! String)
                    self.performSegue(withIdentifier: "healthSegue", sender: [symptom])
                } else {
                    if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "healthSegue" {
            let vc = segue.destination as! MPBookingHealthViewController
            appointment.set(sender as! [McsSymptom])
            vc.setup(appointment)
        }
    }
    
}

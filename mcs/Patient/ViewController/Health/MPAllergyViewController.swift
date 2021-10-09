/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPAllergyViewController: McsFormViewController {
    
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var noteView: UIView!
    private var nameController: McsTextInputControllerAllergy!
    private var noteController: McsTextInputControllerNote!
    private var allergy: McsAllergy?
    
    override func loadView() {
        super.loadView()
        nameController = McsTextInputControllerAllergy.init(nameView, lPlaceHolder: "Allergic_name", pastable: true, require: true, delegate: nil)
        noteController = McsTextInputControllerNote.init(noteView, lPlaceHolder: "Note", pastable: true, require: false, delegate: nil)
        nameController.value = allergy?.name
        noteController.value = allergy?.note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([nameController, noteController])
    }
    
    func setup(_ allergy: McsAllergy) {
        self.allergy = allergy
    }
    
    @IBAction func sendTap(_ sender: Any) {
        endEditing()
        nameController.showErrorIfNeed()
        noteController.showErrorIfNeed()
        if nameController.isValid && noteController.isValid {
            let name = nameController.value as! String
            let note = noteController.value as? String
            if let allergy = allergy {
                if allergy.name != name || allergy.note != note {
                    let allergy = McsAllergy.update(id: allergy.id!,name: name, note: note)
                    // Error description
                    // 404 Not found
                    McsProgressHUD.show(self)
                    McsPatientAllergyUpdateApi.init(McsDatabase.instance.token!, allergy: allergy).run { (success, message, code) in
                        McsProgressHUD.hide(self)
                        if success {
                            McsDatabase.instance.update(allergy)
                            UIAlertController.show(self, title: "Successful".localized, message: nil, close: "Close".localized) {
                                self.navigationController!.popViewController(animated: true)
                            }
                        } else {
                            if code == 404 {
                                McsDatabase.instance.delete(allergy: allergy.id!)
                                self.navigationController!.popViewController(animated: true)
                            } else if code != 403 {
                                UIAlertController.generalErrorAlert(self)
                            }
                        }
                    }
                } else {
                    self.navigationController!.popViewController(animated: true)
                }
            } else {
                let allergy = McsAllergy.create(name: name, note: note)
                McsProgressHUD.show(self)
                McsPatientAllergyCreateApi.init(McsDatabase.instance.token!, allergy: allergy).run { (success, id, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        allergy.id = id
                        McsDatabase.instance.add(allergy)
                        UIAlertController.show(self, title: "Successful".localized, message: nil, close: "Close".localized) {
                            self.navigationController!.popViewController(animated: true)
                        }
                    } else {
                        if code != 403 {
                            UIAlertController.generalErrorAlert(self)
                        }
                    }
                }
            }
        }
    }
    
}

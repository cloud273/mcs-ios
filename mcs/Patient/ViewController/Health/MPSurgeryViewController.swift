/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPSurgeryViewController: McsFormViewController {
    
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var dateView: UIView!
    @IBOutlet private weak var noteView: UIView!
    private var nameController: McsTextInputControllerSurgery!
    private var dateController: McsTextInputControllerMonthYear!
    private var noteController: McsTextInputControllerNote!
    private var surgery: McsSurgery?
    
    override func loadView() {
        super.loadView()
        nameController = McsTextInputControllerSurgery.init(nameView, lPlaceHolder: "Surgery_information", pastable: true, require: true, delegate: nil)
        dateController = McsTextInputControllerMonthYear.init(dateView, lPlaceHolder: "Time", minDate: minDob, maxDate: Date(), require: true, delegate: nil)
        noteController = McsTextInputControllerNote.init(noteView, lPlaceHolder: "Note", pastable: true, require: false, delegate: nil)
        nameController.value = surgery?.name
        dateController.value = surgery?.date
        noteController.value = surgery?.note
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([nameController, dateController, noteController])
    }
    
    func setup(_ surgery: McsSurgery) {
        self.surgery = surgery
    }
    
    @IBAction func sendTap(_ sender: Any) {
        endEditing()
        nameController.showErrorIfNeed()
        dateController.showErrorIfNeed()
        noteController.showErrorIfNeed()
        if nameController.isValid && dateController.isValid && noteController.isValid {
            let name = nameController.value as! String
            let date = dateController.value as! Date
            let note = noteController.value as? String
            if let surgery = surgery {
                if surgery.name != name || surgery.date != date || surgery.note != note {
                    let surgery = McsSurgery.update(id: surgery.id!,name: name, date: date, note: note)
                    // Error description
                    // 404 Not found
                    McsProgressHUD.show(self)
                    McsPatientSurgeryUpdateApi.init(McsDatabase.instance.token!, surgery: surgery).run { (success, message, code) in
                        McsProgressHUD.hide(self)
                        if success {
                            McsDatabase.instance.update(surgery)
                            UIAlertController.show(self, title: "Successful".localized, message: nil, close: "Close".localized) {
                                self.navigationController!.popViewController(animated: true)
                            }
                        } else {
                            if code == 404 {
                                McsDatabase.instance.delete(surgery: surgery.id!)
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
                let surgery = McsSurgery.create(name: name, date: date, note: note)
                McsProgressHUD.show(self)
                McsPatientSurgeryCreateApi.init(McsDatabase.instance.token!, surgery: surgery).run { (success, id, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        surgery.id = id
                        McsDatabase.instance.add(surgery)
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

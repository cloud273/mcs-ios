/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPUpdateAccountViewController: McsFormViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var dobView: UIView!
    @IBOutlet private weak var stateView: UIView!
    @IBOutlet private weak var cityView: UIView!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var genderSegment: UISegmentedControl!
    
    private var nameController: McsTextInputControllerName!
    private var dobController: McsTextInputControllerDate!
    private var lineController: McsTextInputControllerAddress!
    private var cityController: McsTextInputControllerCity!
    private var stateController: McsTextInputControllerState!
    
    private var state: McsState!
    private var country: McsCountry!
    
    override func loadView() {
        super.loadView()
        let account = (McsDatabase.instance.account as! McsPatient)
        state = account.address!.state
        country = account.address!.country
        
        nameController = McsTextInputControllerName.init(nameView, lPlaceHolder: "Fullname", pastable: true, require: true, delegate: nil)
        dobController = McsTextInputControllerDate.init(dobView, lPlaceHolder: "Date_of_birth", minDate: minDob, maxDate: Date(), require: true, delegate: nil)
        stateController = McsTextInputControllerState.init(stateView, lPlaceHolder: "State", country: country, require: true, delegate: self)
        cityController = McsTextInputControllerCity.init(cityView, lPlaceHolder: "City", state: state, require: true, delegate: nil)
        
        lineController = McsTextInputControllerAddress.init(lineView, lPlaceHolder: "Address", pastable: false, require: true, delegate: nil)
        genderSegment.isGenderType()
        
        imageView.setImageUrl(account.image, placeholder: imageView.image)
        nameController.value = account.profile!.fullname
        dobController.value = account.profile!.dob
        genderSegment.gender = account.profile!.gender!
        lineController.value = account.address!.line
        cityController.value = account.address!.city
        stateController.value = account.address!.state
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup([nameController, dobController, stateController, cityController, lineController])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.cornerRadius = imageView.bounds.width/2
        view.setNeedsLayout()
    }
    
    @IBAction func sendTap(_ sender: Any) {
        endEditing()
        nameController.showErrorIfNeed()
        dobController.showErrorIfNeed()
        lineController.showErrorIfNeed()
        cityController.showErrorIfNeed()
        stateController.showErrorIfNeed()
        if nameController.isValid && dobController.isValid && lineController.isValid && cityController.isValid && stateController.isValid {
            let account = (McsDatabase.instance.account as! McsPatient)
            let name = self.nameController.value as! String
            let gender = self.genderSegment.gender
            let dob = self.dobController.value as! Date
            let line = self.lineController.value as! String
            let city = self.cityController.value as! McsCity
            let state = self.stateController.value as! McsState
            if account.profile!.fullname != name || account.profile!.dob != dob || account.profile!.gender != gender || account.address!.country.code != country.code || account.address!.state.code != state.code || account.address!.city.code != city.code || account.address!.line != line {
                let patient = McsPatient.update(firstname: name, lastname: "", gender: self.genderSegment.gender, dob: dob, country: country.code, state: state.code, city: city.code, line: line, longitude: nil, latitude: nil)
                McsProgressHUD.show(self)
                McsPatientUpdateApi.init(McsDatabase.instance.token!, patient: patient).run { (success, message, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        McsDatabase.instance.updateAccount(profile: patient.profile, address: patient.address)
                        UIAlertController.show(self, title: "Successful".localized, message: nil, close: "Close".localized) {
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            } else {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func imageDidTapped(_ sender: Any) {
        QDImagePickerController.show(self, from: imageView, title: "Take_image_title".localized, camera: "Camera".localized, albumn: "Photo_album".localized, cancel: "Cancel".localized) { (success, type, obj) in
            if success {
                var image: UIImage?
                if let obj = obj as? Data {
                    image = UIImage.init(data: obj)
                } else {
                    if let obj = obj as? UIImage {
                        image = obj
                    }
                }
                if let image = image {
                    McsProgressHUD.show(self)
                    McsUploadImageApi.init(image).run { (success, imageName) in
                        if success {
                            if let token = McsDatabase.instance.token {
                                let patient = McsPatient.partialUpdate(image: imageName, language: nil)
                                McsPatientPartialUpdateApi.init(token, patient: patient).run { (success, message, code) in
                                    McsProgressHUD.hide(self)
                                    if success {
                                        McsDatabase.instance.updateAccount(image: imageName, language: nil)
                                        self.imageView.image = image
                                    } else if code != 403 {
                                        UIAlertController.generalErrorAlert(self)
                                    }
                                }
                            } else {
                                McsProgressHUD.hide(self)
                            }
                        } else {
                            McsProgressHUD.hide(self)
                            UIAlertController.generalErrorAlert(self)
                        }
                    }
                }
            }
        }
    }
    
    class func create() -> MPUpdateAccountViewController {
        return UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "updateVc") as! MPUpdateAccountViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emailSegue" {
            
        } else if segue.identifier == "phoneSegue" {
            
        }
    }
    
}

extension MPUpdateAccountViewController: McsTextInputProtocol {
    
    func valueChanged(_ controller: McsTextInputControllerDefault, value: Any?) {
        if controller == stateController {
            let state = (stateController.value as! McsState)
            if state != self.state {
                self.state = state
                cityController.set(state)
                cityController.value = state.cities.first!
            }
        }
    }
    
}

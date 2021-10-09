/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPCreateAccountViewController: McsFormViewController {
    
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
    
    private var username: String!
    private var token: String!
    private var delegate: MPLoginProtocol?
    
    private var state: McsState!
    private var country: McsCountry!
    private var image: UIImage?
    
    override func loadView() {
        super.loadView()
        country = McsAppConfiguration.instance.countries().first!
        state = self.country.states.first!
        
        nameController = McsTextInputControllerName.init(nameView, lPlaceHolder: "Fullname", pastable: true, require: true, delegate: nil)
        dobController = McsTextInputControllerDate.init(dobView, lPlaceHolder: "Date_of_birth", minDate: minDob, maxDate: Date(), require: true, delegate: nil)
        stateController = McsTextInputControllerState.init(stateView, lPlaceHolder: "State", country: country, require: true, delegate: self)
        cityController = McsTextInputControllerCity.init(cityView, lPlaceHolder: "City", state: state, require: true, delegate: nil)
        lineController = McsTextInputControllerAddress.init(lineView, lPlaceHolder: "Address", pastable: false, require: true, delegate: nil)
        genderSegment.isGenderType()
        
        stateController.value = state
        cityController.value = state.cities.first!
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
    
    func setup(_ token: String, username: String, delegate: MPLoginProtocol?) {
        self.username = username
        self.token = token
        self.delegate = delegate
    }
    
    @IBAction func sendTap(_ sender: Any) {
        endEditing()
        nameController.showErrorIfNeed()
        dobController.showErrorIfNeed()
        lineController.showErrorIfNeed()
        cityController.showErrorIfNeed()
        stateController.showErrorIfNeed()
        if nameController.isValid && dobController.isValid && lineController.isValid && cityController.isValid && stateController.isValid {
            McsProgressHUD.show(self)
            uploadImageIfNeed { (success, imageName) in
                if success {
                    let name = self.nameController.value as! String
                    let dob = self.dobController.value as! Date
                    let gender = self.genderSegment.gender
                    let line = self.lineController.value as! String
                    let city = self.cityController.value as! McsCity
                    let state = self.stateController.value as! McsState
                    let patient = McsPatient.create(username: self.username, image: imageName, language: McsDatabase.instance.language, firstname: name, lastname: "", gender: gender, dob: dob, country: self.country.code, state: state.code, city: city.code, line: line, longitude: nil, latitude: nil)
                    // Error description
                    // 401 Invalid email or phone => should not happen
                    // 403 Invalid/Expired token
                    // 409 Existed email or phone
                    McsPatientCreateApi.init(self.token, patient: patient).run { (success, id, code) in
                        if success {
                            McsPatientDetailApi.init(self.token).run { (success, account, code) in
                                McsProgressHUD.hide(self)
                                if success {
                                    McsProgressHUD.hide(self)
                                    McsDatabase.instance.setAccount(account!, token: self.token!)
                                    self.dismiss(animated: true, completion: {
                                        self.delegate?.didSuccess()
                                    })
                                } else {
                                    UIAlertController.show(self, title: "Error".localized, message: "Login_again".localized, close: "Close".localized) {
                                        self.hide()
                                    }
                                }
                            }
                        } else {
                            McsProgressHUD.hide(self)
                            if code == 409 {
                                UIAlertController.show(self, title: "Error".localized, message: "Existed_account_please_login".localized, close: "Close".localized) {
                                    self.hide()
                                }
                            } else if code != 403 {
                                UIAlertController.generalErrorAlert(self)
                            }
                        }
                    }
                } else {
                    McsProgressHUD.hide(self)
                    UIAlertController.generalErrorAlert(self)
                }
            }
        }
    }
    
    private func uploadImageIfNeed(_ completion: @escaping (_ success: Bool,_ imageName: String?) -> Void) {
        if let image = image {
            McsUploadImageApi.init(image).run { (success, imageName) in
                completion(success, imageName)
            }
        } else {
            completion(true, nil)
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
                    self.image = image
                    self.imageView.image = image
                }
            }
        }
    }
    
    func hide() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MPCreateAccountViewController: McsTextInputProtocol {
    
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

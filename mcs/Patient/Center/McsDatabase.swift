/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/01/04.
 */

import UIKit

class McsDatabase : McsBaseDatabase {
    
    static let instance = McsDatabase()
    
    override var accountType: McsAccountType {
        get {
            return .patient
        }
    }
    
    override func updateAccount(_ account: McsAccount) {
        if token != nil, let old = self.account as? McsPatient, let account = account as? McsPatient {
            account.allergies = old.allergies
            account.surgeries = old.surgeries
            account._medications = old._medications
            super.updateAccount(account)
        }
    }
    
    func updateAccount(allergies : [McsAllergy]?, surgeries : [McsSurgery]?, medications : [McsMedication]?) {
        if token != nil, let patient = account as? McsPatient {
            patient.allergies = allergies
            patient.surgeries = surgeries
            patient._medications = medications
            NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
        }
    }
    
    func updateAccount(profile : McsProfile, address: McsAddress) {
        if token != nil, let patient = account as? McsPatient {
            let genderChanged = patient.profile!.gender != profile.gender
            patient.profile = profile
            patient.address = address
            if genderChanged {
                NotificationCenter.default.post(name: accountGenderDidUpdatedNotification, object: nil)
            }
            NotificationCenter.default.post(name: accountInfoDidChangeNotification, object: nil)
        }
    }
    
    func updateAccount(image : String?, language: McsLanguage?) {
        if token != nil, let patient = account as? McsPatient {
            patient.imageName = image
            patient.language = language
            NotificationCenter.default.post(name: accountInfoDidChangeNotification, object: nil)
        }
    }
    
    func updateAccount(username : String) {
        if token != nil, let patient = account as? McsPatient {
            patient.username = username
            NotificationCenter.default.post(name: accountInfoDidChangeNotification, object: nil)
        }
    }
    
    func add(_ allery: McsAllergy) {
        if token != nil, let patient = self.account as? McsPatient {
            var allergies = patient.allergies ?? []
            let found = allergies.contains(where: { (candidate) -> Bool in
                return candidate.id == allery.id
            })
            if !found {
                allergies.append(allery)
                patient.allergies = allergies
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
    func update(_ allery: McsAllergy) {
        if token != nil, let patient = self.account as? McsPatient {
            var allergies = patient.allergies ?? []
            let index = allergies.firstIndex(where: { (candidate) -> Bool in
                return candidate.id == allery.id
            })
            if let index = index {
                allergies[index] = allery
                patient.allergies = allergies
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
    func delete(allergy id: Int) {
        if token != nil, let patient = self.account as? McsPatient {
            let allergies = patient.allergies?.filter({ (candidate) -> Bool in
                return candidate.id != id
            })
            if allergies?.count != patient.allergies?.count {
                patient.allergies = allergies
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
    func add(_ surgery: McsSurgery) {
        if token != nil, let patient = self.account as? McsPatient {
            var surgeries = patient.surgeries ?? []
            let found = surgeries.contains(where: { (candidate) -> Bool in
                return candidate.id == surgery.id
            })
            if !found {
                surgeries.append(surgery)
                patient.surgeries = surgeries
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
    func update(_ surgery: McsSurgery) {
        if token != nil, let patient = self.account as? McsPatient {
            var surgeries = patient.surgeries ?? []
            let index = surgeries.firstIndex(where: { (candidate) -> Bool in
                return candidate.id == surgery.id
            })
            if let index = index {
                surgeries[index] = surgery
                patient.surgeries = surgeries
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
    func delete(surgery id: Int) {
        if token != nil, let patient = self.account as? McsPatient {
            let surgeries = patient.surgeries?.filter({ (candidate) -> Bool in
                return candidate.id != id
            })
            if surgeries?.count != patient.surgeries?.count {
                patient.surgeries = surgeries
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
    func update(_ medication: McsMedication) {
        if token != nil, let patient = self.account as? McsPatient {
            var medications = patient.medications ?? []
            let index = medications.firstIndex(where: { (candidate) -> Bool in
                return candidate.id == medication.id
            })
            if let index = index {
                medications[index] = medication
                patient._medications = medications
                NotificationCenter.default.post(name: accountHealthInfoDidChangeNotification, object: nil)
            }
        }
    }
    
}

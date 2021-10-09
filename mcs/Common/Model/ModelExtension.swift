/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/03.
*/

import UIKit
import QDCore
import CLLocalization

protocol McsTextProtocol: Any  {
    
    func getText() -> String

}

extension Array: McsTextProtocol where Element: Any {
    
    func getText() -> String {
        var result: String = ""
        for obj in self {
            if result.count > 0 {
                result.append("\n")
            }
            if let symptom = obj as? McsSymptom {
                result.append("+ \(symptom.name!): \(symptom.note!)")
            } else if let allergy = obj as? McsAllergy {
                var string = "+ \(allergy.name!)"
                if let note = allergy.note, !note.isEmpty {
                    string += ": \(note)"
                }
                result.append(string)
            } else if let surgery = obj as? McsSurgery {
                var string = "+ \(surgery.name!)(\(surgery.date.toAppMonthYearString()))"
                if let note = surgery.note, !note.isEmpty {
                    string += ": \(note)"
                }
                result.append(string)
            } else if let medication = obj as? McsMedication {
                if result.count > 0 {
                    result.append("\n")
                }
                result.append("+ \(medication.name!.getText()): \(medication.value.getText())")
            } else if let obj = obj as? McsTextProtocol {
                result.append("+ \(obj.getText())")
            } else if let string = obj as? String {
                result.append("+ \(string)")
            }
        }
        return result
    }
    
}

extension McsAddress {
    
    var country: McsCountry {
        get {
            return McsAppConfiguration.instance.country(countryCode)!
        }
    }
    
    var state: McsState {
        get {
            return McsAppConfiguration.instance.state(stateCode)!
        }
    }
    
    var city: McsCity {
        get {
            return McsAppConfiguration.instance.city(cityCode)!
        }
    }
    
    func toString() -> String {
        if let line = line {
            return "\(line), \(city.name), \(state.name)"
        } else {
            return ""
        }
    }
    
}

extension McsAllergy: McsTextDetailProtocol {
    
    public func getText() -> String {
        return name
    }
    
    func getDetail() -> String? {
        return note
    }
    
}

extension McsAppointment {
    
    public var acceptable: Bool? {
        if let status = status {
            return status.value == .created && begin!.addingTimeInterval(McsAppConfiguration.instance.acceptableEnd()) > today
        } else {
            return nil
        }
    }
    
    public var rejectable: Bool? {
        if let status = status {
            return status.value == .created
                && begin!.addingTimeInterval(McsAppConfiguration.instance.rejectableEnd()) > today
        } else {
            return nil
        }
    }
    
    public var cancelable: Bool? {
        if let status = status {
            return (status.value == .created || status.value == .accepted)
                && begin!.addingTimeInterval(McsAppConfiguration.instance.cancelableEnd()) > today
        } else {
            return nil
        }
    }
    
    public var beginable: Bool? {
        if let status = status {
            return status.value == .accepted
                && begin!.addingTimeInterval(McsAppConfiguration.instance.beginableEnd()) > today
                && begin!.addingTimeInterval(McsAppConfiguration.instance.beginableFrom()) < today
        } else {
            return nil
        }
    }
    
    public var finishable: Bool? {
        if let status = status {
            return status.value == .started
                && begin!.addingTimeInterval(McsAppConfiguration.instance.finishableEnd()) > today
        } else {
            return nil
        }
    }
    
    private var today: Date {
        return QDGlobalTime.instance.getDate() ?? Date()
    }
    
    var specialty: McsSpecialty {
        get {
            return McsAppConfiguration.instance.specialty(specialtyCode)!
        }
    }
    
    public static func create(_ type: McsPackageType) -> McsAppointment {
        let result = McsAppointment.init(JSON: [:])!
        result.type = type
        return result
    }
    
    public func set(_ symptoms: [McsSymptom]) {
        self.symptoms = symptoms
    }
    
    public func set(_ allergies: [McsAllergy]?, surgeries: [McsSurgery]?, medications: [McsMedication]?) {
        self.allergies = allergies
        self.surgeries = surgeries
        self.medications = medications
    }
    
    public func set(_ package: McsPackage) {
        self.packageId = package.id!
        self.price = package.price
        self.visitTime = package.visitTime
    }
    
    public func set(_ specialtyCode: String) {
        self.specialtyCode = specialtyCode
    }
    
    public func set(_ begin: Date) {
        self.begin = begin
    }
    
}

extension McsAptStatusType {
    
    func toString() -> String {
        var result : String!
        switch self {
        case .created:
            result = "Created_status".localized
            break
        case .accepted:
            result = "Accepted_status".localized
            break
        case .rejected:
            result = "Rejected_status".localized
            break
        case .cancelled:
            result = "Cancelled".localized
            break
        case .started:
            result = "In_progress".localized
            break
        default:
            result = "Finished".localized
        }
        return result
    }
    
}

extension McsCertificate {
    
    @objc func title() -> String {
        return ""
    }
    
}

extension McsCity {
    
    var name: String {
        get {
            return nameMap[McsDatabase.instance.language.rawValue]!
        }
    }
    
}

extension McsCity: QDKbTextProtocol {
    
    public func getText() -> String {
        return name
    }
    
    public func equal(_ object: Any?) -> Bool {
        return code == (object as? McsCity)?.code
    }
    
}

extension McsClinicCert {

    override func title() -> String {
        return type.toString()
    }

}

extension McsClinicCertType {
    
    func toString() -> String {
        switch self {
        case .working:
            return "Clinic_working_certificate".localized
        default:
            return "Clinic_other_certificate".localized
        }
    }
    
}

extension McsCountry {
    
    var name: String {
        get {
            return nameMap[McsDatabase.instance.language.rawValue]!
        }
    }
    
}

extension McsCountry: QDKbTextProtocol {
    
    public func getText() -> String {
        return name
    }
    
    public func equal(_ object: Any?) -> Bool {
        return code == (object as? McsCountry)?.code
    }
}

extension McsDoctor {
    
    func specialtiesString(_ preferSpecialtyCode: String?) -> String {
        var result = ""
        if let specialtyCodes = specialtyCodes {
            for code in specialtyCodes {
                if let specialty = McsAppConfiguration.instance.specialty(code) {
                    if code == preferSpecialtyCode {
                        if result.count > 0 {
                            result = specialty.name + ", " + result
                        } else {
                            result = specialty.name
                        }
                    } else {
                        if result.count > 0 {
                            result += ", "
                        }
                        result += specialty.name
                    }
                }
            }
        }
        return result
    }
    
}

extension McsDoctorCert {

    override func title() -> String {
        return type.toString()
    }

}

extension McsDoctorCertType {

    func toString() -> String {
        switch self {
        case .personal:
            return "ID".localized
        case .working:
            return "Doctor_working_certificate".localized
        case .degree:
            return "Degree".localized
        default:
            return "Doctor_other_certificate".localized
        }
    }

}

extension McsGender {
    
    func toString() -> String {
        switch self {
        case .male:
            return "Male".localized
        default:
            return "Female".localized
        }
    }
    
}

extension McsMedication: McsCheckCellDataProtocol {
    
    func getText() -> String {
        return name.getText()
    }
    
    func isOn() -> Bool {
        return value == .yes
    }
}

extension McsMedicationType {
    
    var order: Int {
        get {
            switch self {
            case .highBP:
                return 1
            case .highCholesterol:
                return 2
            case .pregnant:
                return 3
            case .cancer:
                return 4
            }
        }
    }
    
    func getText() -> String {
        switch self {
        case .highBP:
            return "High_bp".localized
        case .highCholesterol:
            return "High_cholesterol".localized
        case .pregnant:
            return "Pregnant".localized
        case .cancer:
            return "Cancer".localized
        }
    }
    
}

extension McsNotifyType {
    
    func getText() -> String {
        switch self {
        case .sms:
            return "sms".localized
        case .email:
            return "email".localized
        }
    }
    
}

extension McsPackage {
    
    var specialty: McsSpecialty {
        get {
            return McsAppConfiguration.instance.specialty(specialtyCode)!
        }
    }
    
    func durationString() -> String {
        return (visitTime / 60).toString() + " " + "Minute_unit".localized
    }
    
}


extension McsPackageType {
    
    func toString() -> String {
        switch self {
        case .telemed:
            return "Telemedicine".localized
        default:
            return "Exam_at_clinic".localized
        }
    }
    
}

extension McsPatient {
    
    var medications : [McsMedication]? {
        get {
            var result: [McsMedication]?
            if let list = _medications {
                result = []
                for obj in list {
                    if profile!.gender == .female || obj .name != .pregnant {
                        result?.append(obj )
                    }
                }
            }
            return result?.sorted(by: { (t1, t2) -> Bool in
                return t1.name!.order < t2.name!.order
            })
        }
    }
    
}

extension McsPrice {
    
    func toString() -> String {
        var locale: String
        if currency == .vnd {
            locale = "vi_VN"
        } else {
            locale = "en_US"
        }
        return String.currency(amount!, locale: locale)!
    }
    
}

extension McsProfile {
    
    var fullname: String {
        get {
            var result = ""
            if firstname.count > 0 {
                result += firstname
            }
            if lastname.count > 0 {
                if result.count > 0 {
                    result += " "
                }
                result += lastname
            }
            return result
        }
    }
    
}

extension McsSpecialty {
    
    var name: String {
        get {
            return nameMap[McsDatabase.instance.language.rawValue]!
        }
    }
    
}

extension McsSpecialty: McsTextProtocol {
    
    func getText() -> String {
        return name
    }
    
}

extension McsState {
    
    var name: String {
        get {
            return nameMap[McsDatabase.instance.language.rawValue]!
        }
    }
    
}

extension McsState: QDKbTextProtocol {
    
    public func getText() -> String {
        return name
    }
    
    public func equal(_ object: Any?) -> Bool {
        return code == (object as? McsState)?.code
    }
}

extension McsSurgery: McsTextDetailProtocol {
    
    public func getText() -> String {
        return "\(name!) (\(date!.toAppMonthYearString()))"
    }
    
    func getDetail() -> String? {
        return note
    }
}

extension McsTrilean  {
    func getText() -> String {
        switch self {
        case .yes:
            return "Yes".localized
        case .no:
            return "No".localized
        default:
            return "Unknown".localized
        }
    }
}

extension McsUserType {
    
    func toString() -> String {
        var result : String!
        switch self {
        case .patient:
            result = "Patient".localized
            break
        case .clinic:
            result = "Clinic".localized
            break
        case .doctor:
            result = "Doctor".localized
            break
        default:
            result = "System".localized
        }
        return result
    }
    
}

extension McsValue {
    
    var name: String {
        get {
            return nameMap[McsDatabase.instance.language.rawValue]!
        }
    }
    
}

extension McsValue : QDKbTextProtocol {
    
    public func getText() -> String {
        return name
    }
    
    public func equal(_ other: Any?) -> Bool {
        return self == (other as? McsValue)
    }
    
}

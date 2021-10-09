/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import Foundation

public enum McsAccountType : String {
    case patient = "patient"
    case doctor = "doctor"
}

public enum McsAptStatusType : String {
    case created = "created"
    case accepted = "accepted"
    case started = "started"
    case rejected = "rejected"
    case cancelled = "cancelled"
    case finished = "finished"
}


public enum McsClinicCertType : String {
    case working = "working"
    case other = "other"
}

public enum McsCurrency : String {
    case vnd = "vnd"
    case usd = "usd"
}

public enum McsDoctorCertType : String {
    case personal = "personal"
    case working = "working"
    case degree = "degree"
    case other = "other"
}

public enum McsGender : String {
    case male = "male"
    case female = "female"
}

public enum McsLanguage : String {
    case vietnamese = "vi"
    case english = "en"
}

public enum McsMedicationType : String {
    case highBP = "highBP"
    case highCholesterol = "highCholesterol"
    case pregnant = "pregnant"
    case cancer = "cancer"
}

public enum McsNotifyType : String {
    case email = "email"
    case sms = "sms"
}

public enum McsPackageType : String {
    
    case classic = "classic"
    case telemed = "telemed"
    
}

public enum McsTrilean : String {
    case yes = "yes"
    case no = "no"
    case unknown = "unknown"
}

public enum McsUserType : String {
    case patient = "patient"
    case clinic = "clinic"
    case doctor = "doctor"
    case system = "system"
}

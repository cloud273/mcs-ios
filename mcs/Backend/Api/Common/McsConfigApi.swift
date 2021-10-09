/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsConfigApi: McsRequestApi {
    
    fileprivate class Output : Mappable {
        
        fileprivate class Reason : Mappable {
            
            var patientCancel: [McsValue]!
            var clinicReject: [McsValue]!
            var systemReject: [McsValue]!
            
            required init?(map: Map) {}
            
            func mapping(map: Map) {
                patientCancel       <- map["patientCancel"]
                clinicReject        <- map["clinicReject"]
                systemReject        <- map["systemReject"]
            }
            
        }
        
        fileprivate class AppointmentInfo : Mappable {
            
            fileprivate class Duration : Mappable {
                
                var from: TimeInterval!
                var to: TimeInterval!
                
                required init?(map: Map) {}
                
                func mapping(map: Map) {
                    from        <- map["from"]
                    to          <- map["to"]
                }
                
            }
            
            var creatable: TimeInterval!
            var acceptable: TimeInterval!
            var cancelable: TimeInterval!
            var rejectable: TimeInterval!
            var beginable: Duration!
            var finishable: TimeInterval!
            
            required init?(map: Map) {}
            
            func mapping(map: Map) {
                creatable       <- map["creatable"]
                acceptable      <- map["acceptable"]
                cancelable      <- map["cancelable"]
                rejectable      <- map["rejectable"]
                beginable       <- map["beginable"]
                finishable      <- map["finishable"]
            }
            
        }
        
        var countries: [McsCountry]!
        var specialties: [McsSpecialty]!
        var reasons: Reason!
        var appointmentInfo: AppointmentInfo!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            countries           <- map["countries"]
            specialties         <- map["specialties"]
            reasons              <- map["reasons"]
            appointmentInfo     <- map["appointment"]
        }
        
    }
    
    override public func api() -> String {
        return "/config"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    public func run(_ completion: @escaping (_ success: Bool,_ countries: [McsCountry]?,_ specialties: [McsSpecialty]?,_ patientCancel: [McsValue]?,_ clinicReject: [McsValue]?,_ systemReject: [McsValue]?,_ creatableEnd: TimeInterval?, _ acceptableEnd: TimeInterval?,_ cancalableEnd: TimeInterval?,_ rejectableEnd: TimeInterval?,_ beginableFrom: TimeInterval?,_ beginableEnd: TimeInterval?,_ finishableEnd: TimeInterval?) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.countries, output.specialties, output.reasons.patientCancel, output.reasons.clinicReject, output.reasons.systemReject, output.appointmentInfo.creatable, output.appointmentInfo.acceptable, output.appointmentInfo.cancelable, output.appointmentInfo.rejectable, output.appointmentInfo.beginable.from, output.appointmentInfo.beginable.to, output.appointmentInfo.finishable)
            } else {
                completion(false, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
            }
        }
    }
    
}


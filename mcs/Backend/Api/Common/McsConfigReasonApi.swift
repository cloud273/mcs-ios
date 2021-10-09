/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsConfigReasonApi: McsRequestApi {
    
    private class Output : Mappable {
        
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
    
    override public func api() -> String {
        return "/config/reasons"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    public func run(_ completion: @escaping (_ success: Bool,_ patientCancel: [McsValue]?,_ clinicReject: [McsValue]?,_ systemReject: [McsValue]?) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.patientCancel, output.clinicReject, output.systemReject)
            } else {
                completion(false, nil, nil, nil)
            }
        }
    }
    
}


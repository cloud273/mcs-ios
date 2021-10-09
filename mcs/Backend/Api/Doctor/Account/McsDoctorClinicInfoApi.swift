/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/01.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsDoctorClinicInfoApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var doctor: McsDoctor!
        var clinic: McsClinic!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            doctor          <- map["doctor"]
            clinic          <- map["clinic"]
        }
        
    }
    
    override public func api() -> String {
        return "/doctor/info"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }

    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool,_ data: McsDoctor?, _ clinic: McsClinic?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.doctor, output.clinic, code)
            } else {
                completion(false, nil, nil, code)
            }
        }
    }
    
}

/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/03.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsDoctorClinicDetailApi: McsUserRequestApi {
    
    override public func api() -> String {
        return "/doctor/clinic"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }

    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool,_ data: McsClinic?,_ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = McsClinic.init(JSON: data) {
                completion(true, output, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


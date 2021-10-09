/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/04.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientDetailApi: McsUserRequestApi {
    
    public required override init(_ token: String) {
        super.init(token)
    }
    
    override public func api() -> String {
        return "/patient"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }

    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool,_ data: McsPatient?,_ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = McsPatient.init(JSON: data) {
                completion(true, output, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}

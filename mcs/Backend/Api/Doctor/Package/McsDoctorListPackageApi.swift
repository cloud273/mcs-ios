/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/03.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsDoctorListPackageApi: McsUserRequestApi {
    
    override public func api() -> String {
        return "/doctor/package/list"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool, _ data: [McsPackage]?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [[String: Any]] {
                completion(true, Array<McsPackage>.init(JSONArray: data), code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/15.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientListDoctorApi: McsUserRequestApi {
    
    private var type: McsPackageType
    private var specialtyCode: String
    
    public required init(_ token: String, type: McsPackageType, specialtyCode: String) {
        self.type = type
        self.specialtyCode = specialtyCode
        super.init(token)
    }
    
    override public func api() -> String {
        return "/patient/booking/doctor/list?type=\(type.rawValue)&specialty=\(specialtyCode)"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool, _ data: [McsDoctor]?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [[String: Any]] {
                completion(true, Array<McsDoctor>.init(JSONArray: data), code)
            } else {
                completion(false, nil, code)
            }
        }
    }
}


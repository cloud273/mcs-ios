/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/15.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientDoctorDetailApi: McsUserRequestApi {
    
    private var id: Int
    private var type: McsPackageType
    private var specialtyCode: String
    
    public required init(_ token: String, id: Int, type: McsPackageType, specialtyCode: String) {
        self.id = id
        self.type = type
        self.specialtyCode = specialtyCode
        super.init(token)
    }
    
    override public func api() -> String {
        return "/patient/booking/doctor?id=\(id)&type=\(type.rawValue)&specialty=\(specialtyCode)"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found doctorId
    public func run(_ completion: @escaping (_ success: Bool, _ data: McsDoctor?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = McsDoctor.init(JSON: data) {
                completion(true, output, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
}


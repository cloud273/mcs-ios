/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/15.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientListSpecialtyApi: McsUserRequestApi {
    
    private var symptoms: [McsSymptom]
    
    public required init(_ token: String, symptoms: [McsSymptom]) {
        self.symptoms = symptoms
        super.init(token)
    }
    
    override public func api() -> String {
        return "/patient/booking/specialty/list?symptoms=\(symptoms.toJSONString()!.base64Encode())"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool, _ data: [McsSpecialty]?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [[String: Any]] {
                completion(true, Array<McsSpecialty>.init(JSONArray: data), code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


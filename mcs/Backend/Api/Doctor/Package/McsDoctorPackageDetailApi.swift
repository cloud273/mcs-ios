/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/04.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsDoctorPackageDetailApi: McsUserRequestApi {
    
    private var id: Int
    
    public required init(_ token: String, id: Int) {
        self.id = id
        super.init(token)
    }
    
    override public func api() -> String {
        return "/doctor/package?id=\(id)"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    public func run(_ completion: @escaping (_ success: Bool, _ data: McsPackage?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = McsPackage.init(JSON: data) {
                completion(true, output, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}

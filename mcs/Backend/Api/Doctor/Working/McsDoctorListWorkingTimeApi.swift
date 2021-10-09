/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/12.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsDoctorListWorkingTimeApi: McsUserRequestApi {
    
    private var from: Date
    private var to: Date
    
    public required init(_ token: String, from: Date, to: Date) {
        self.from = from
        self.to = to
        super.init(token)
    }
    
    override public func api() -> String {
        return "/doctor/working-time/list?from=\(from.toApiDateTimeString().encodeQuery())&to=\(to.toApiDateTimeString().encodeQuery())"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool, _ data: [McsWorkingTime]?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [[String: Any]] {
                completion(true, Array<McsWorkingTime>.init(JSONArray: data), code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


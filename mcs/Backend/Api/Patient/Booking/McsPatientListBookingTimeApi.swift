/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/15.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientListBookingTimeApi: McsUserRequestApi {
    
    private var packageId: Int
    private var from: Date
    private var to: Date
    
    public required init(_ token: String, packageId: Int, from: Date, to: Date) {
        self.packageId = packageId
        self.from = from
        self.to = to
        super.init(token)
    }
    
    override public func api() -> String {
        return "/patient/booking/time/list?packageId=\(packageId)&from=\(from.toApiDateTimeString().encodeQuery())&to=\(to.toApiDateTimeString().encodeQuery())"
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found packageId
    public func run(_ completion: @escaping (_ success: Bool, _ data: [String]?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String] {
                completion(true, data, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


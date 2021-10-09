/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/06.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsDoctorListAppointmentApi: McsUserRequestApi {
    
    private var type: McsPackageType?
    private var statusTypes: [McsAptStatusType]?
    private var from: Date
    private var to: Date
    
    public required init(_ token: String, type: McsPackageType?, statusTypes: [McsAptStatusType]?, from: Date, to: Date) {
        self.type = type
        self.statusTypes = statusTypes
        self.from = from
        self.to = to
        super.init(token)
    }
    
    override public func api() -> String {
        var result = "/doctor/appointment/list?from=\(from.toApiDateTimeString().encodeQuery())&to=\(to.toApiDateTimeString().encodeQuery())"
        if let type = type {
            result.append("&type=\(type.rawValue)")
        }
        if let statusTypes = statusTypes, statusTypes.count > 0 {
            var jsonStatus = [String]()
            for statusType in statusTypes {
                jsonStatus.append(statusType.rawValue)
            }
            result.append("&statusTypes=\(jsonStatus.toJsonString()!.base64Encode())")
        }
        return result
    }
    
    override public func method() -> HTTPMethod {
        return .get
    }
    
    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool, _ data: [McsAppointment]?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [[String: Any]] {
                completion(true, Array<McsAppointment>.init(JSONArray: data), code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


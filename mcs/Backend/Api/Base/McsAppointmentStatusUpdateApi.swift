/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/25.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsAppointmentStatusUpdateApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var message: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            message     <- map["message"]
        }
        
    }
    
    private var id: Int
    private var note: String
    private var _api: String
    
    init(_ api: String, token: String, id: Int, note: String) {
        self._api = api
        self.id = id
        self.note = note
        super.init(token)
    }
    
    override public func body() -> [String : Any]? {
        var result = [String : Any]()
        result["id"] = id
        result["note"] = note
        return result
    }
    
    override public func api() -> String {
        return _api
    }
    
    public override func method() -> HTTPMethod {
        return .patch
    }
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    // 406 Cannot be processed
    public func run(_ completion: @escaping (_ success: Bool,_ message: String?,_ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.message, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


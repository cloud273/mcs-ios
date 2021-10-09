/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/26.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientActivateApi: McsRequestApi {
    
    private class Output : Mappable {
        
        var message: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            message     <- map["message"]
        }
        
    }
    
    private var username : String
    private var code : String
    
    required init(_ username: String, code: String) {
        self.username = username
        self.code = code
    }
    
    override public func api() -> String {
        return "/patient/activate"
    }
    
    override public func body() -> [String : Any]? {
        return [
            "username": username,
            "code": code
        ]
    }
    
    override public func method() -> HTTPMethod {
        return .patch
    }
    
    // Error description
    // 403 Invalid code
    // 404 Not found
    // 406 Expired code
    public func run(_ completion: @escaping (_ success: Bool, _ mesage: String?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.message, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


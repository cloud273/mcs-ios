/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/01/18.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsAccountResetPasswordApi: McsRequestApi {
    
    private class Output : Mappable {
        
        var message: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            message     <- map["message"]
        }
        
    }
    
    private var type : McsAccountType
    private var username : String
    private var password : String
    private var code : String
    
    required init(_ type: McsAccountType, username: String, password: String, code: String) {
        self.type = type
        self.username = username
        self.password = password
        self.code = code
    }
    
    override public func api() -> String {
        return "/\(type.rawValue)/reset-password"
    }
    
    override public func body() -> [String : Any]? {
        return [
            "username": username,
            "password": password,
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
    public func run(_ completion: @escaping (_ success: Bool,_ mesage: String?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.message, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}

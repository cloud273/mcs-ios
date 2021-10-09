/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/01/18.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsAccountUpdatePasswordApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var token: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            token       <- map["token"]
        }
        
    }
    
    private var type : McsAccountType
    private var password : String
    private var newPassword : String
    
    required init(_ type: McsAccountType, token: String, password: String, newPassword: String) {
        self.type = type
        self.password = password
        self.newPassword = newPassword
        super.init(token)
    }
    
    override public func api() -> String {
        return "/\(type.rawValue)/update-password"
    }
    
    override public func body() -> [String : Any]? {
        return [
            "password": password,
            "newPassword": newPassword
        ]
    }
    
    override public func method() -> HTTPMethod {
        return .patch
    }
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Invalid password
    public func run(_ completion: @escaping (_ success: Bool,_ token: String?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.token, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


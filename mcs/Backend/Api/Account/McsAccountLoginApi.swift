/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsAccountLoginApi: McsRequestApi {
    
    private class Output : Mappable {
        
        var token: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            token         <- map["token"]
        }
        
    }
    
    private var type : McsAccountType
    private var username : String
    private var password : String
    private var deviceToken : String?
    private var production: Bool
    
    public required init(_ type: McsAccountType, username: String, password: String, deviceToken: String?) {
        self.type = type
        self.username = username
        self.password = password
        self.deviceToken = deviceToken
        #if RELEASE
            self.production = true
        #else
            self.production = false
        #endif
    }
    
    override public func api() -> String {
        return "/\(type.rawValue)/login"
    }
    
    override public func body() -> [String : Any]? {
        let login = [
            "username": username,
            "password": password
        ]
        var device : [String: Any] = [
            "info" : UIDevice.current.info,
            "os" : "ios",
            "topic" : String.bundleIdentifier,
            "production": production
        ]
        if let deviceToken = deviceToken {
            device["token"] = deviceToken
        }
        return [
            "login": login,
            "device": device
        ]
    }
    
    override public func method() -> HTTPMethod {
        return .post
    }
    
    // Error description
    // 401 Invalid password
    // 403 Inactivated account
    // 404 Not found
    // 423 Account is locked
    public func run(_ completion: @escaping (_ success: Bool,_ token: String?,_ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200 || code == 202, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.token, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


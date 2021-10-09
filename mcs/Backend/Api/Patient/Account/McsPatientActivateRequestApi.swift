/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/26.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientActivateRequestApi: McsRequestApi {
    
    private class Output : Mappable {
        
        var type: McsNotifyType!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            type         <- map["code"]
        }
        
    }
    
    private var username : String
    private var language : McsLanguage
    
    public required init(_ username: String, language: McsLanguage) {
        self.username = username
        self.language = language
    }
    
    override public func api() -> String {
        return "/patient/activate-request"
    }
    
    override public func headers() -> [String : String]? {
        var result = super.headers()!
        result["language"] = language.rawValue
        return result
    }
    
    override public func body() -> [String : Any]? {
        return [
            "username": username
        ]
    }
    
    override public func method() -> HTTPMethod {
        return .patch
    }
    
    // Error description
    // 404 Not found
    public func run(_ completion: @escaping (_ success: Bool,_ type: McsNotifyType?, _ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.type, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


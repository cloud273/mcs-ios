/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/01/18.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsAccountDeviceSetApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var id: Int!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            id     <- map["id"]
        }
        
    }
    private var type : McsAccountType
    private var deviceToken : String?
    private var production: Bool
    
    public init(_ type: McsAccountType, userToken: String, deviceToken: String?) {
        self.type = type
        self.deviceToken = deviceToken
        #if RELEASE
            self.production = true
        #else
            self.production = false
        #endif
        super.init(userToken)
    }
    
    public override func api() -> String {
        return "/\(type.rawValue)/device"
    }
    override public func body() -> [String : Any]? {
        var result : [String: Any] = [
            "info" : UIDevice.current.info,
            "os" : "ios",
            "topic" : String.bundleIdentifier,
            "production": production
        ]
        if let deviceToken = deviceToken {
            result["token"] = deviceToken
        }
        return result
    }
    
    // Error description
    // 404 Not found
    public func run(_ completion: @escaping (_ code: Int,_ id: Int?) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(code, output.id)
            } else {
                completion(code, nil)
            }
        }
    }
    
}

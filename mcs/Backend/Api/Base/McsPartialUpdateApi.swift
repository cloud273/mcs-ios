/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/11.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPartialUpdateApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var message: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            message         <- map["message"]
        }
        
    }
    
    private var obj: McsBase
    private var _api: String
    
    init(_ api: String, token: String, obj: McsBase) {
        obj.validPartialUpdate()
        self.obj = obj
        self._api = api
        super.init(token)
    }
    
    public override func api() -> String {
        return _api
    }
    
    override public func body() -> [String : Any]? {
        return obj.toJSON()
    }
    
    override public func method() -> HTTPMethod {
        return .patch
    }
    
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

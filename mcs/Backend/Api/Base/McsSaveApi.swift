/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/01/18.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsSaveApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var id: Int!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            id         <- map["id"]
        }
        
    }
    
    private var obj: McsBase
    private var _api: String
    
    init(_ api: String, token: String, obj: McsBase) {
        obj.validCreated()
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
        return .post
    }
    
    public func run(_ completion: @escaping (_ success: Bool,_ id: Int?,_ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 201 || code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.id, code)
            } else {
                completion(false, nil, code)
            }
        }
    }
    
}


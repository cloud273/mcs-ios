/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/04.
*/

import UIKit

let expiredTokenNotification = NSNotification.Name.init("expiredTokenNotification")

public class McsUserRequestApi: McsRequestApi {
    
    private var token: String

    public init(_ token: String) {
        self.token = token
    }
    
    override public func headers() -> [String : String]? {
        var result = super.headers()!
        result["token"] = token
        return result
    }
    
    override func commonFetch(_ queue: DispatchQueue = DispatchQueue.main, completion: @escaping (_ code: Int, _ error: Error?, _ data: Any?) -> Void) {
        fetch(queue) { (code, error, data) in
            completion(code, error, data)
            if code == 403 {
                NotificationCenter.default.post(name: expiredTokenNotification, object: nil)
            }
        }
    }
    
}

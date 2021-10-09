/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import QDCore

public class McsRequestApi: QDRequestApi {
    
    override public func baseUrl() -> String {
        return ApiUrl
    }
    
    override public func headers() -> [String : String]? {
        return [
            "app" : String.bundleIdentifier + "|" + String.bundleShortVersion,
            "os": "ios"
        ]
    }
    
    override public func log() -> QDLog? {
        return apiLog
    }
    
    override public func timeout() -> TimeInterval {
        return 30
    }
    
    func commonFetch(_ queue: DispatchQueue = DispatchQueue.main, completion: @escaping (_ code: Int, _ error: Error?, _ data: Any?) -> Void) {
        fetch(queue) { (code, error, data) in
            completion(code, error, data)
        }
    }
    
}

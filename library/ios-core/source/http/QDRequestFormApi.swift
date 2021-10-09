/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

import UIKit
import Alamofire

open class QDRequestFormApi: QDRequestApi {
    
    public class FormData {
        
        public var data: Data
        
        public var filename: String
        
        public var mime: String
        
        public init(_ data : Data, filename : String, mime : String) {
            self.data = data
            self.filename = filename
            self.mime = mime
        }
        
    }
    
    open func thresholdByte() -> UInt64 {
        return 20_000_000 //(20 megabyte)
    }
    
    open func formData() -> [String : FormData] {
        return [:]
    }
    
    private func getData (_ obj : Any) -> Data? {
        if let str = obj as? String {
            return str.data(using: .utf8)
        } else {
            if let num = obj as? Int {
                return String(num).data(using: .utf8)
            } else {
                if let num = obj as? Double {
                    return String(num).data(using: .utf8)
                } else {
                    if let num = obj as? Float {
                        return String(num).data(using: .utf8)
                    }
                }
            }
        }
        return nil
    }
    
    override func requestString() -> String {
        var result = super.requestString()
        let formData = self.formData()
        for (key, value) in formData {
            result = String.init(format: "%@\n%@", result, "formData = \(key):\(value.filename):\(value.mime)")
        }
        return result
    }
    
    public override func fetch(_ queue: DispatchQueue = DispatchQueue.main, completion: @escaping ((Int, Error?, Any?) -> Void)) {
        let _url = baseUrl() + api()
        let _method = method()
        let _headers = getHeaders()
        
        let fs = formData()
        let multipartFormData = MultipartFormData.init()
        for (key, value) in fs {
            multipartFormData.append(value.data, withName: key, fileName: value.filename, mimeType: value.mime)
        }
        let pas = body()
        if let parameters = pas {
            for (key, value) in parameters {
                let data = self.getData(value)!
                multipartFormData.append(data, withName: key)
            }
        }
        let request = AF.upload(multipartFormData: multipartFormData, to: _url, usingThreshold: thresholdByte(), method: _method, headers: _headers) { (request) in
            request.timeoutInterval = self.timeout()
            request.cachePolicy = .reloadIgnoringCacheData
        }
        responseJson(queue, request: request, completion: completion)
    }
    
}



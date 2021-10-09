/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */


import UIKit

import UIKit
import Alamofire

open class QDRequestApi: NSObject {
    
    open func api() -> String {
        return ""
    }

    open func baseUrl() -> String {
        return ""
    }

    open func method() -> HTTPMethod {
        return .post
    }

    open func headers() -> [String : String]? {
        return nil
    }
    
    open func body() -> [String : Any]? {
        return nil
    }

    open func log() -> QDLog? {
        return nil
    }
    
    open func timeout() -> TimeInterval {
        return 30
    }
    
    open func getHeaders() -> HTTPHeaders? {
        let tmp = headers()
        return tmp != nil ? HTTPHeaders.init(tmp!) : nil
    }
    
    func requestString() -> String {
        var result = "-----------------------Request-----------------------"
        result = String.init(format: "%@\n%@", result, "url = \(baseUrl())\(api())")
        result = String.init(format: "%@\n%@", result, "method = \(self.method())")
        if let headers = self.headers() {
            result = String.init(format: "%@\n%@", result, "headers = \(String(describing: headers))")
        }
        if let body = self.body() {
            result = String.init(format: "%@\n%@", result, "body = \(String(describing: body))")
        }
        return result
    }
    
    func responseString(_ code: Int, error: Error?, data: Any?) -> String {
        var result = "-----------------------Response-----------------------"
        result = String.init(format: "%@\n%@", result, "code = \(code)")
        if data != nil {
            result = String.init(format: "%@\n%@", result, "data = \(String(describing: data))")
        }
        if error != nil {
            result = String.init(format: "%@\n%@", result, "error = \(String(describing: error))")
        }
        return result
    }

    func getErrorCode(_ error: Error) -> Int {
        var code: Int
        if let error = error as? AFError {
            code = error._code
        } else if let error = error as? URLError {
            code = error.code.rawValue
        } else {
            code = URLError.unknown.rawValue
        }
        return code
    }
    
    func responseJson(_ queue : DispatchQueue, request: DataRequest, completion: @escaping ((Int, Error?, Any?) -> Void)) {
        request.responseJSON(queue: queue, options: .allowFragments) { (response) in
            let data = response.value;
            let error = response.error
            let code = response.response?.statusCode ?? ((error != nil) ? self.getErrorCode(error!) : URLError.unknown.rawValue)
            if let log = self.log() {
                let txt = "\(self.requestString()) \n\(self.responseString(code, error: error, data: data))"
                log.add(txt)
            }
            completion(code, error, data)
        }
    }
    
    public func fetch(_ queue : DispatchQueue = DispatchQueue.main, completion: @escaping ((Int, Error?, Any?) -> Void)) {
        let _url = baseUrl() + api()
        let _method = method()
        let _headers = getHeaders()
        let _parameters = body()
        let request = AF.request(_url, method: _method, parameters : _parameters, encoding : JSONEncoding.default, headers : _headers) { (request) in
            request.timeoutInterval = self.timeout()
            request.cachePolicy = .reloadIgnoringCacheData
        }
        responseJson(queue, request: request, completion: completion)
    }
}



/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/18.
*/

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsUploadImageApi: McsRequestFormApi {
    
    private class Output : Mappable {
        
        var imageName: String!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            imageName       <- map["image"]
        }
        
    }
    
    private var image : UIImage
    
    public required init(_ image : UIImage) {
        self.image = image
    }
    
    override public func api() -> String {
        return "/upload/image"
    }
    
    public override func formData() -> [String : QDRequestFormApi.FormData] {
        return ["image": QDRequestFormApi.FormData.init(image.data()!, filename: "", mime: "image/png")]
    }
    
    override public func method() -> HTTPMethod {
        return .post
    }
    
    public func run(_ completion: @escaping (_ success: Bool,_ imageName: String?) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.imageName)
            } else {
                completion(false, nil)
            }
        }
    }
    
}


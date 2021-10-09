/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsCertificate : McsBase {
    
    public var code : String!
    public var name : String!
    public var issuer : String!
    public var issueDate : Date!
    public var expDate : Date?
    public var imageName : String?
    
    public var image: String? {
        get {
            if let name = imageName {
                return "\(ImageUrl)/\(name)"
            } else {
                return nil
            }
        }
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        code            <- map["code"]
        name            <- map["name"]
        issuer          <- map["issuer"]
        issueDate       <- (map["issueDate"], DayTransform())
        expDate         <- (map["expDate"], DayTransform())
        imageName       <- map["image"]
    }
    
}

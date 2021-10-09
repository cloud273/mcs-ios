/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsClinic : McsBase {
    
    public var name : String!
    public var imageName : String?
    public var email : String!
    public var phone : String!
    public var workPhone : String?
    public var address : McsAddress!
    public var certificates : [McsClinicCert]?
    
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
        name            <- map["name"]
        imageName       <- map["image"]
        email           <- map["email"]
        phone           <- map["phone"]
        workPhone       <- map["workPhone"]
        address         <- map["address"]
        certificates    <- map["certificates"]
    }
    
}

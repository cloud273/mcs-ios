/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/01.
*/

import UIKit
import ObjectMapper

public class McsSpecialty : McsMappable {
    
    public var code : String!
    public var imageName: String!
    public var nameMap : [String: String]!
    
    public var image: String? {
        get {
            if let name = imageName {
                return "\(ResourceUrl)/\(name)"
            } else {
                return nil
            }
        }
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        code        <- map["code"]
        imageName   <- map["image"]
        nameMap     <- map["name"]
    }

}

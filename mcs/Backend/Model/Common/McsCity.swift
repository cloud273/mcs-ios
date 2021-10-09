/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/01.
*/

import UIKit
import ObjectMapper

public class McsCity : McsMappable {
    
    public var code : String!
    public var nameMap : [String: String]!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        code        <- map["code"]
        nameMap     <- map["name"]
    }
    
}

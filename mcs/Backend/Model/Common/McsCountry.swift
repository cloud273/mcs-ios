/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/01.
*/

import UIKit
import ObjectMapper

public class McsCountry: McsMappable {
    
    public var code : String!
    public var nameMap : [String: String]!
    public var states : [McsState]!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        code        <- map["code"]
        nameMap     <- map["name"]
        states      <- map["state"]
    }

}

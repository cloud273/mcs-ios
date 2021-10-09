/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsState : McsMappable {
    
    public var code : String!
    public var nameMap : [String: String]!
    public var cities : [McsCity]!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        code        <- map["code"]
        nameMap     <- map["name"]
        cities      <- map["city"]
    }

}

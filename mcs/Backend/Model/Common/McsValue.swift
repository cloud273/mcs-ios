/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsValue : McsMappable {
    
    public var code : Any!
    public var nameMap : [String: String]!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        code        <- map["code"]
        nameMap     <- map["name"]
    }

}

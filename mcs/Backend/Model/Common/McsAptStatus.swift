/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsAptStatus: McsBase {
    
    public var by: McsUserType!
    public var value: McsAptStatusType!
    public var note: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        by          <- map["by"]
        value       <- map["value"]
        note        <- map["description"]
    }
    
}

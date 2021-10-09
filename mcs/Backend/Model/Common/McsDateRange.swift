/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsDateRange : McsMappable {
    
    public var from: Date!
    public var to: Date!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        from        <- (map["from"], DayTransform())
        to          <- (map["to"], DayTransform())
    }
    
}

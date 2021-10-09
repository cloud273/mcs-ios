/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsSchedule : McsBase {
    
    public var duration: McsDateRange!
    public var monday: [McsTimeRange]!
    public var tuesday: [McsTimeRange]!
    public var wednesday: [McsTimeRange]!
    public var thursday: [McsTimeRange]!
    public var friday: [McsTimeRange]!
    public var saturday: [McsTimeRange]!
    public var sunday: [McsTimeRange]!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        duration        <- map["duration"]
        monday          <- map["monday"]
        tuesday         <- map["tuesday"]
        wednesday       <- map["wednesday"]
        thursday        <- map["thursday"]
        friday          <- map["friday"]
        saturday        <- map["saturday"]
        sunday          <- map["sunday"]
    }
    
}

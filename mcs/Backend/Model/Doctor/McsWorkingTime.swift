/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsWorkingTime : McsBase {
    
    public var begin: Date!
    public var end: Date!
    public var visitTime: Int!
    public var packageId: Int?
    public var scheduleId: Int?
    public var workingDayId: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        begin           <- (map["begin"], DateTimeTransform())
        end             <- (map["end"], DateTimeTransform())
        visitTime       <- map["visitTime"]
        packageId       <- map["packageId"]
        scheduleId      <- map["scheduleId"]
        workingDayId    <- map["workingDayId"]
    }
    
}

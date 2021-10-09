/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsPackage : McsBase {
    
    public var specialtyCode : String!
    public var price : McsPrice!
    public var type : McsPackageType!
    public var visitTime : Int!
    public var note : String?
    public var schedules : [McsSchedule]?
    public var workingDays : [McsWorkingDay]?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        specialtyCode       <- map["specialty"]
        price               <- map["price"]
        type                <- map["type"]
        visitTime           <- map["visitTime"]
        note                <- map["note"]
        schedules           <- map["schedules"]
        workingDays         <- map["workingDays"]
    }
    
}

/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsWorkingDay : McsBase {
    
    public var date: Date!
    public var times: [McsTimeRange]!
    public var packageId: Int!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        date            <- (map["date"], DayTransform())
        times           <- map["times"]
        packageId       <- map["packageId"]
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    private init(id: Int?, date: Date?, times: [McsTimeRange]?, packageId: Int?)  {
        super.init()
        self.id = id
        self.date = date
        self.times = times
        self.packageId = packageId
    }
    
    public class func create(date: Date, times: [McsTimeRange], packageId: Int) -> McsWorkingDay {
        return McsWorkingDay.init(id: nil, date: date, times: times, packageId: packageId)
    }
    
    public class func update(id: Int, date: Date, times: [McsTimeRange]) -> McsWorkingDay {
        return McsWorkingDay.init(id: id, date: date, times: times, packageId: nil)
    }
    
}

/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsTimeRange : McsMappable {
    
    public var _fromString: String!
    public var _toString: String!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        _fromString      <- map["from"]
        _toString        <- map["to"]
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    private init(from: Date, to: Date)  {
        super.init()
        self._fromString = from.toTimeApiString()
        self._toString = to.toTimeApiString()
    }
    
    public class func create(from: Date, to: Date) -> McsTimeRange {
        return McsTimeRange.init(from: from, to: to)
    }
    
    public class func update(from: Date, to: Date) -> McsTimeRange {
        return McsTimeRange.init(from: from, to: to)
    }
    
}

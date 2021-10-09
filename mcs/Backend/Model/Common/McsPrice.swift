/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsPrice: McsMappable {
    
    public var amount: Double!
    public var currency: McsCurrency!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        amount          <- map["amount"]
        currency        <- map["currency"]
    }
    
}

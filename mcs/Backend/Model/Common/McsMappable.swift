/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsMappable : NSObject, Mappable {
    
    override public init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        
    }
    
}

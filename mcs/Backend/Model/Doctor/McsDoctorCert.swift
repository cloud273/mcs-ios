/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsDoctorCert : McsCertificate {
    
    public var type : McsDoctorCertType!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        type            <- map["type"]
    }
    
}

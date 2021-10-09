/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsMedication : McsBase {
    
    public var name : McsMedicationType!
    public var value : McsTrilean!
    public var note : String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        name        <- map["name"]
        value       <- map["value"]
        note        <- map["description"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    private init(id: Int?, name: McsMedicationType?, value: McsTrilean?, note: String?)  {
        super.init()
        self.id = id
        self.name = name
        self.value = value
        self.note = note
    }
    
    public class func update(id: Int, value : McsTrilean, note : String?) -> McsMedication {
        return McsMedication.init(id: id, name: nil, value: value, note: note)
    }
    
}

/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsAllergy : McsBase {
    
    public var name : String!
    public var note : String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        name            <- map["name"]
        note            <- map["description"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    private init(id: Int?, name: String?, note: String?)  {
        super.init()
        self.id = id
        self.name = name
        self.note = note
    }
    
    public class func create(name : String, note : String?) -> McsAllergy {
        return McsAllergy.init(id: nil, name: name, note: note)
    }
    
    public class func update(id: Int, name : String, note : String?) -> McsAllergy {
        return McsAllergy.init(id: id, name: name, note: note)
    }
    
}

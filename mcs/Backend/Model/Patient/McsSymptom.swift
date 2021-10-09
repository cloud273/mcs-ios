/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsSymptom: McsMappable {
    
    public var name : String!
    public var note : String!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        name        <- map["name"]
        note        <- map["note"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    private init(name: String?, note: String)  {
        super.init()
        self.name = name
        self.note = note
    }
    
    public class func create(name : String, note : String) -> McsSymptom {
        return McsSymptom.init(name: name, note: note)
    }
    
}

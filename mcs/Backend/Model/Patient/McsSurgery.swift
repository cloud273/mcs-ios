/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsSurgery : McsBase {
    
    public var name : String!
    public var date : Date!
    public var note : String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        name        <- map["name"]
        date        <- (map["date"], DayTransform())
        note        <- map["description"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    private init(id: Int?, name: String, date: Date, note: String?)  {
        super.init()
        self.id = id
        self.date = date
        self.name = name
        self.note = note
    }
    
    public class func create(name : String, date: Date, note : String?) -> McsSurgery {
        return McsSurgery.init(id: nil, name: name, date: date, note: note)
    }
    
    public class func update(id: Int, name : String, date: Date, note : String?) -> McsSurgery {
        return McsSurgery.init(id: id, name: name, date: date, note: note)
    }
    
}

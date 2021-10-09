/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsBase : McsMappable {
    
    public var id : Int?
    public var createdAt : Date?
    public var updatedAt : Date?
    public var deletedAt : Date?
    
    override public func mapping(map: Map) {
        id              <- map["id"]
        createdAt       <- (map["createdAt"], DateTimeTransform())
        updatedAt       <- (map["updatedAt"], DateTimeTransform())
        deletedAt       <- (map["deletedAt"], DateTimeTransform())
    }
    
    public func validCreated()  {

    }
    
    public func validUpdate()  {
        
    }
    
    public func validPartialUpdate()  {
        
    }
    
}

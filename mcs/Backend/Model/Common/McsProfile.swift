/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsProfile : McsMappable {
    
    public var firstname : String!
    public var lastname : String!
    public var gender : McsGender!
    public var dob : Date!
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        firstname       <- map["firstname"]
        lastname        <- map["lastname"]
        gender          <- map["gender"]
        dob             <- (map["dob"], DayTransform())
    }
    
    private init(firstname: String, lastname: String, gender: McsGender, dob: Date) {
        super.init()
        self.firstname = firstname
        self.lastname = lastname
        self.gender = gender
        self.dob = dob
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public class func create(firstname: String, lastname: String, gender: McsGender, dob: Date) -> McsProfile {
        return McsProfile.init(firstname: firstname, lastname: lastname, gender: gender, dob: dob)
    }
    
    public class func update(firstname: String, lastname: String, gender: McsGender, dob: Date) -> McsProfile {
        return McsProfile.init(firstname: firstname, lastname: lastname, gender: gender, dob: dob)
    }
    
}

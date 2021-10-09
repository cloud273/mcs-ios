/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsDoctor : McsAccount {
    
    public var rating: Double! = 4.5
    public var noFb: Int! = 125
    public var favorite: Bool? = false
    public var noApt: Int! = 214
    public var title: String!
    public var biography : String?
    public var office : String?
    public var timezone : String?
    public var startWork: Date?
    public var certificates: [McsDoctorCert]?
    public var specialtyCodes: [String]?
    public var clinic: McsClinic?
    public var packages: [McsPackage]?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        rating          <- map["rating"]
        noFb            <- map["noFb"]
        favorite        <- map["favorite"]
        noApt           <- map["noApt"]
        title           <- map["title"]
        biography       <- map["biography"]
        office          <- map["office"]
        timezone        <- map["timezone"]
        startWork       <- (map["startWork"], DayTransform())
        certificates    <- map["certificates"]
        specialtyCodes  <- map["specialties"]
        clinic          <- map["clinic"]
        packages        <- map["packages"]
    }
    
}

/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsAddress : McsMappable {
    
    public var countryCode : String!
    public var stateCode : String!
    public var cityCode : String!
    public var line : String!
    public var longitude : Double?
    public var latitude : Double?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        countryCode     <- map["country"]
        stateCode       <- map["state"]
        cityCode        <- map["city"]
        line            <- map["line"]
        longitude       <- map["longitude"]
        latitude        <- map["latitude"]
    }
    
    private init(country: String, state: String, city: String, line: String, longitude: Double?, latitude: Double?) {
        super.init()
        self.countryCode = country
        self.stateCode = state
        self.cityCode = city
        self.line = line
        self.longitude = longitude
        self.latitude = latitude
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public class func create(country: String, state: String, city: String, line: String, longitude: Double?, latitude: Double?) -> McsAddress {
        return McsAddress.init(country: country, state: state, city: city, line: line, longitude: longitude, latitude: latitude)
    }
    
    public class func update(country: String, state: String, city: String, line: String, longitude: Double?, latitude: Double?) -> McsAddress {
        return McsAddress.init(country: country, state: state, city: city, line: line, longitude: longitude, latitude: latitude)
    }
    
}



/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsPatient : McsAccount {
    
    public var address : McsAddress!
    public var allergies : [McsAllergy]?
    public var surgeries : [McsSurgery]?
    public var _medications : [McsMedication]?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        address         <- map["address"]
        allergies       <- map["allergies"]
        surgeries       <- map["surgeries"]
        _medications     <- map["medications"]
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    private init(username: String?, image: String?, language: McsLanguage?, profile: McsProfile?, address: McsAddress?)  {
        super.init()
        self.username = username
        self.imageName = image
        self.language = language
        self.profile = profile
        self.address = address
    }
    
    public class func create(username: String, image: String?, language: McsLanguage, firstname: String, lastname: String, gender: McsGender, dob: Date, country: String, state: String, city: String, line: String, longitude: Double?, latitude: Double?) -> McsPatient {
        return McsPatient.init(username: username, image: image, language: language, profile: McsProfile.create(firstname: firstname, lastname: lastname, gender: gender, dob: dob),  address: McsAddress.create(country: country, state: state, city: city, line: line, longitude: longitude, latitude: latitude))
    }
    
    public class func update(firstname: String, lastname: String, gender: McsGender, dob: Date, country: String, state: String, city: String, line: String, longitude: Double?, latitude: Double?) -> McsPatient {
        return McsPatient.init(username: nil, image: nil, language: nil, profile: McsProfile.update(firstname: firstname, lastname: lastname, gender: gender, dob: dob),  address: McsAddress.update(country: country, state: state, city: city, line: line, longitude: longitude, latitude: latitude))
    }
    
    public class func partialUpdate(image: String?, language: McsLanguage?) -> McsPatient {
        return McsPatient.init(username: nil, image: image, language: language, profile: nil,  address: nil)
    }
    
}

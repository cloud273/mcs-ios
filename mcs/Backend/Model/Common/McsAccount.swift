/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import ObjectMapper

public class McsAccount : McsBase {
    
    public var username : String!
    public var imageName : String?
    public var language : McsLanguage!
    public var profile : McsProfile!
    
    public var image: String? {
        get {
            if let name = imageName {
                return "\(ImageUrl)/\(name)"
            } else {
                return nil
            }
        }
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        profile         <- map["profile"]
        username        <- map["username"]
        imageName       <- map["image"]
        language        <- map["language"]
    }
    
}

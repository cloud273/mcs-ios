/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/05.
 */

import UIKit
import Alamofire
import QDCore
import ObjectMapper

public class McsPatientHealthDetailApi: McsUserRequestApi {
    
    private class Output : Mappable {
        
        var allergies: [McsAllergy]!
        
        var surgeries: [McsSurgery]!
        
        var medications: [McsMedication]!
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            allergies       <- map["allergies"]
            surgeries       <- map["surgeries"]
            medications     <- map["medications"]
        }
        
    }
    
    public required override init(_ token: String) {
        super.init(token)
    }
    
    public override func api() -> String {
        return "/patient/health"
    }
    
    public override func method() -> HTTPMethod {
        return .get
    }

    // Error description
    // 403 Invalid/Expired token
    public func run(_ completion: @escaping (_ success: Bool,_ allergies: [McsAllergy]?,_ surgeries: [McsSurgery]?,_ medications: [McsMedication]?,_ code: Int) -> Void) {
        commonFetch { (code, error, data) in
            if code == 200, let data = data as? [String: Any], let output = Output.init(JSON: data) {
                completion(true, output.allergies, output.surgeries, output.medications, code)
            } else {
                completion(false, nil, nil, nil, code)
            }
        }
    }
    
}

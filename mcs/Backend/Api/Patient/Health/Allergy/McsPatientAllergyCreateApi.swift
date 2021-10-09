/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/05.
 */

import UIKit

public class McsPatientAllergyCreateApi: McsCreateApi {
    
    // Error description
    // 403 Invalid/Expired token
    public required init(_ token: String, allergy: McsAllergy) {
        super.init("/patient/health/allergy", token: token, obj: allergy)
    }
    
}


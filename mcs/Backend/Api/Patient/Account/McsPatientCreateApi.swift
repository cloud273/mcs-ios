/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/06.
 */

import UIKit

public class McsPatientCreateApi: McsCreateApi {
    
    // Error description
    // 401 Invalid email or phone
    // 403 Invalid/Expired token
    // 409 Existed email or phone
    public required init(_ token: String, patient: McsPatient) {
        super.init("/patient", token: token, obj: patient)
    }
    
}

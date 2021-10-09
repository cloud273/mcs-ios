/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/04.
 */

import UIKit

public class McsPatientUpdateApi: McsUpdateApi {
    
    // Error description
    // 403 Invalid/Expired token
    public required init(_ token: String, patient: McsPatient) {
        super.init("/patient", token: token, obj: patient)
    }

}

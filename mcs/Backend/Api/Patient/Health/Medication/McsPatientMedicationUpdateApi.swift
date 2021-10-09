/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/05.
 */

import UIKit

public class McsPatientMedicationUpdateApi: McsUpdateApi {
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    public required init(_ token: String, medication: McsMedication) {
        super.init("/patient/health/medication", token: token, obj: medication)
    }
    
}


/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/05.
 */

import UIKit

public class McsPatientSurgeryCreateApi: McsCreateApi {

    // Error description
    // 403 Invalid/Expired token
    public required init(_ token: String, surgery: McsSurgery) {
        super.init("/patient/health/surgery", token: token, obj: surgery)
    }
    
}


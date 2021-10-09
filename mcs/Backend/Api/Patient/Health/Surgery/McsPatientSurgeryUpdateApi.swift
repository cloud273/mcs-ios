/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/05.
 */

import UIKit

public class McsPatientSurgeryUpdateApi: McsUpdateApi {

    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    public required init(_ token: String, surgery: McsSurgery) {
        super.init("/patient/health/surgery", token: token, obj: surgery)
    }
    
}


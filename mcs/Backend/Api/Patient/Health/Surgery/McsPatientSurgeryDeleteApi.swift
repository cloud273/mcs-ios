/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/05.
 */

import UIKit

public class McsPatientSurgeryDeleteApi: McsDeleteApi {
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    public required init(_ token: String, id: Int) {
        super.init("/patient/health/surgery?id=\(id)", token: token)
    }
    
}


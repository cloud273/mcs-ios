/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/25.
 */

import UIKit

public class McsPatientCancelAppointmentApi: McsAppointmentStatusUpdateApi {
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    // 406 Cannot be cancelled
    public init(_ token: String, id: Int, note: String) {
        super.init("/patient/appointment/cancel", token: token, id: id, note: note)
    }
    
}


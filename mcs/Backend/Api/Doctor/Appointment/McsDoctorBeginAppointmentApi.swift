/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/06.
 */

import UIKit

public class McsDoctorBeginAppointmentApi: McsAppointmentStatusUpdateApi {
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    // 406 Cannot be started
    public init(_ token: String, id: Int, note: String) {
        super.init("/doctor/appointment/begin", token: token, id: id, note: note)
    }
    
}


/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/06.
 */

import UIKit

public class McsDoctorFinishAppointmentApi: McsAppointmentStatusUpdateApi {
    
    // Error description
    // 403 Invalid/Expired token
    // 404 Not found
    // 406 Cannot be finished
    public init(_ token: String, id: Int, note: String) {
        super.init("/doctor/appointment/finish", token: token, id: id, note: note)
    }
    
}


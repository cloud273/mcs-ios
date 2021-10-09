/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/24.
 */

import UIKit

public class McsPatientAppointmentCreateApi: McsCreateApi {
    
    // Error description
    // 403 Invalid/Expired token
    // 406 Bad data or data changed
    public required init(_ token: String, appointment: McsAppointment) {
        super.init("/patient/appointment", token: token, obj: appointment)
    }
    
}


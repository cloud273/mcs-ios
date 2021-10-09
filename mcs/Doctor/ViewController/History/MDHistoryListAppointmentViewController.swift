/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/06.
 */

import UIKit
import QDCore

class MDHistoryListAppointmentViewController: MDListAppointmentViewController {

    private var packageType: McsPackageType = .classic
    
    override func getAppointments(_ completion: @escaping (Bool, [McsAppointment]?) -> Void) {
        if let token = McsDatabase.instance.token {
            let today = QDGlobalTime.instance.getDate() ?? Date()
            let to = today.dateByAdd(day: 1)!
            let from = today.dateByAdd(month: -12)!.firstDayOfThisMonth()
            McsDoctorListAppointmentApi.init(token, type: packageType, statusTypes: [.finished], from: from, to: to).run() { (success, appointments, code) in
                completion(success, appointments)
            }
        } else {
            completion(false, nil)
        }
    }
    
}

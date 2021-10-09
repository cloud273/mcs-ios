/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/03.
*/

import UIKit
import QDCore
import CLLocalization

extension McsTimeRange  {
    
    var from: Date? {
        get {
            let doctor = McsDatabase.instance.account as! McsDoctor
            return Date.dateAppTimeFormat(_fromString!, timezone: doctor.timezone!)
        }
    }
    
    var to: Date? {
        get {
            let doctor = McsDatabase.instance.account as! McsDoctor
            return Date.dateAppTimeFormat(_toString!, timezone: doctor.timezone!)
        }
    }
    
    var fromText: String {
        get {
            return from?.toAppTimeString() ?? _fromString!
        }
    }
    
    var toText: String {
        get {
            return to?.toAppTimeString() ?? _toString!
        }
    }

}

extension McsAppointment {
    
    var isActive: Bool {
        get {
            return beginable! || finishable! || rejectable! 
        }
    }
    
    var isToday: Bool {
        get {
            return begin.isSameDayAs(Date())
        }
    }
    
}

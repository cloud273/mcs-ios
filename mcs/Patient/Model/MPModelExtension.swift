/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/03.
*/

import UIKit
import QDCore
import CLLocalization

extension McsAppointment {
    
    var isActive: Bool {
        get {
             return beginable! || finishable! || cancelable!
        }
    }
    
}

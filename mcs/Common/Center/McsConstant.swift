/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import Foundation
import UIKit
import QDCore

let accountDidClearNotification = NSNotification.Name("accountDidClearNotification")
let accountDidSetNotification = NSNotification.Name("accountDidSetNotification")
let accountGenderDidUpdatedNotification = NSNotification.Name("accountGenderDidUpdatedNotification")
let accountHealthInfoDidChangeNotification = NSNotification.Name("accountHealthInfoDidChangeNotification")
let accountInfoDidChangeNotification = NSNotification.Name("accountInfoDidChangeNotification")
let accountWillLogoutNotification = NSNotification.Name("accountWillLogoutNotification")
let appointmentDidUpdatedNotification = NSNotification.Name("appointmentDidUpdatedNotification")
let moveToAppointmentListNotification = NSNotification.Name("moveToAppointmentListNotification")
let scheduleDidUpdatedNotification = NSNotification.Name("scheduleDidUpdatedNotification")

let profileIcon = UIImage.init(named: "profile")!
let patientIcon = UIImage.init(named: "profile")!
let doctorIcon = UIImage.init(named: "doctor")!
let clinicIcon = UIImage.init(named: "no-image")!
let certificateIcon = UIImage.init(named: "no-image")!
let specialtyIcon = UIImage.init(named: "no-image")!



let minWorkingDuration: TimeInterval = 3600
let minTimeDuration: TimeInterval = 3600*24*7
let minSummaryDuration: TimeInterval = 3600*24

let minDob = Date.date(year: 1930, month: 1, day: 1)

let defaultCreatableEnd: TimeInterval = 3600*(-18)
let defaultAcceptableEnd: TimeInterval = 3600*(-6)
let defaultCancelableEnd: TimeInterval = 3600*(-6)
let defaultRejectableEnd: TimeInterval = 3600*(-6)
let defaultBeginableFrom: TimeInterval = 3600*(-12)
let defaultBeginableEnd: TimeInterval = 3600*12
let defaultFinishableEnd: TimeInterval = 3600*12

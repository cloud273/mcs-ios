/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class MPAppointmentCell: McsCell {
    
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let appointment = data as! McsAppointment
        doctorImageView.setImageUrl(appointment.doctorInfo!.image , placeholder: doctorIcon)
        doctorLabel.text = appointment.doctorInfo!.title!.localized + ": " + appointment.doctorInfo!.profile.fullname
        specialtyLabel.text = appointment.specialty.name
        timeLabel.text = appointment.begin.toAppDateTimeString()
        statusLabel.text = appointment.status?.value.toString()
    }
    
}

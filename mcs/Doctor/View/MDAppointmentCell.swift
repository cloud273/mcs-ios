/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class MDAppointmentCell: QDTableCell {
    
    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var defaultImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultImage = patientImageView.image
    }
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let appointment = data as! McsAppointment
        patientImageView.setImageUrl(appointment.patientInfo!.image, placeholder: patientIcon)
        patientLabel.text = appointment.patientInfo!.profile!.fullname
        specialtyLabel.text = appointment.specialty.name
        timeLabel.text = appointment.begin.toAppDateTimeString()
        statusLabel.text = "\("Order".localized) \(appointment.order!.toString()) - \(appointment.status!.value.toString())" 
    }
    
}

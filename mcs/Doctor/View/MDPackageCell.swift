/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/21.
 */

import UIKit
import QDCore

class MDPackageCell: QDTableCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let package = data as! McsPackage
        titleLabel.text = package.type.toString()
        priceLabel.text = "Price".localized + ": " + package.price!.toString()
        timeLabel.text = "Appointment_duration".localized + ": " + package.durationString()
        specialtyLabel.text = "Specialty".localized + ": " + package.specialty.name
    }
    
}

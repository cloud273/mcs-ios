/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class MPClinicCell: McsCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let clinic = data as! McsClinic
        nameLabel.text = clinic.name
        phoneLabel.text = "\("Phone".localized): \(clinic.phone!)"
        addressLabel.text = "\("Address".localized): \(clinic.address!.toString())"
    }
    
}
